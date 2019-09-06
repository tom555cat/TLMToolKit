//
//  XCMonitorReport.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "XCMonitorReport.h"
#import <AFNetworking.h>
#import "XCMonitorHeader.h"
#import "XCMonitorDataAdapter.h"
#import "XCMonitor.h"
#import "XCMonitorLog.h"

@implementation XCMonitorReport

+ (instancetype)sharedReport {
    static XCMonitorReport *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XCMonitorReport alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMonitorData:) name:XCMonitorNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)processMonitorData:(NSNotification *)notification {
    id<XCMonitorDataAdapter> dataAdapter = notification.object;
    if ([[XCMonitor sharedMonitor] monitorUseMode] == XCMonitorUseInDevelop) {
        if ([dataAdapter respondsToSelector:@selector(report)]) {
            NSDictionary *logMsg = [dataAdapter report];
            NSString *name = logMsg[XCMonitorReportNameKey];
            NSString *content = logMsg[XCMonitorReportContentKey];
            [self uploadStackTrack:content traceName:name withCompletion:^(NSError *error) {
                if (error) {
                    NSLog(@"主动上传日志遇到错误，中断上传!");
                    [[XCMonitorLog sharedLogger] storeToDiskWithMessage:content fileName:name];
                    return;
                } else {
                    NSLog(@"上传日志成功");
                }
            }];
        }
    }
}

- (void)uploadLocalLogFiles {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<NSString *> *filePaths = [[NSFileManager defaultManager] subpathsAtPath:[[XCMonitorLog sharedLogger] diskPath]];
        for (NSString *fileName in filePaths) {
            NSString *fullName = [[[XCMonitorLog sharedLogger] diskPath] stringByAppendingPathComponent:fileName];
            NSString *content = [NSString stringWithContentsOfFile:fullName encoding:NSUTF8StringEncoding error:nil];
            [self uploadStackTrack:content traceName:fileName withCompletion:^(NSError *error) {
                if (error) {
                    NSLog(@"主动上传日志遇到错误，中断上传!");
                    return;
                } else {
                    NSLog(@"上传日志成功");
                    [[NSFileManager defaultManager] removeItemAtPath:fullName error:nil];
                }
            }];
        }
    });
}

- (void)uploadStackTrack:(NSString *)traceContent traceName:(NSString *)traceName withCompletion:(nullable void (^)(NSError *error))completion {
    if (traceContent.length <= 0 || traceName.length <= 0) {
        return;
    }
    NSString *URLString = @"http://10.36.32.247:3000/stacklog";
    NSDictionary *parameters = @{@"name": traceName, @"content": traceContent};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
    
    [dataTask resume];
}

@end

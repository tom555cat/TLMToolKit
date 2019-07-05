//
//  XCStackTrack.m
//  Pods
//
//  Created by tongleiming on 2019/6/26.
//

#import "XCStackTrack.h"
#import <CrashReporter/CrashReporter.h>
#import <AFNetworking.h>
//#include <execinfo.h>

//void handleSignalException(int signal) {
//    NSMutableString *crashString = [[NSMutableString alloc]init];
//    void* callstack[128];
//    int i, frames = backtrace(callstack, 128);
//    char** traceChar = backtrace_symbols(callstack, frames);
//    for (i = 0; i <frames; ++i) {
//        [crashString appendFormat:@"%s\n", traceChar[i]];
//    }
//    NSLog(@"--------Background Task Stack---------");
//    NSLog(@"%@", crashString);
//}

@interface XCStackTrack ()

@property (nonatomic, copy) NSArray<NSString *> *labelsForTrackType;
@property (nonatomic, strong) NSString *diskPath;

@end

@implementation XCStackTrack

+ (instancetype)sharedManager {
    static XCStackTrack *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XCStackTrack alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _labelsForTrackType = @[@"backgroundTask",
                                @"UILag",
                                @"OOM"];
        _diskPath = [self makeDiskPath];
    }
    return self;
}

- (NSString *)makeDiskPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *stackTrackDirectory = [paths[0] stringByAppendingPathComponent:@"XCStackTrack"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:stackTrackDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:stackTrackDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return stackTrackDirectory;
}

- (NSString *)makeStorePathWithFileName:(NSString *)fileName {
    if (fileName.length == 0) {
        return nil;
    }
    NSString *logPath = [NSString stringWithFormat:@"%@/%@", self.diskPath, fileName];
    return logPath;
}

- (void)storeToDiskForStackFrames:(NSString *)stackFrames fileName:(NSString *)fileName {
    NSString *storePath = [self makeStorePathWithFileName:fileName];
    [stackFrames writeToFile:storePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)trackStack {
    NSData *lagData = [[[PLCrashReporter alloc]
                        initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
    PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
    NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
    // 将日志保存到本地
    //将字符串上传服务器
    return lagReportString;
    //NSLog(@"lag happen, detail below: \n %@",lagReportString);
}

- (void)uploadStackTrack:(NSString *)traceContent traceName:(NSString *)traceName {
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
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}

- (void)uploadLocalStackFramesFiles {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<NSString *> *filePaths = [[NSFileManager defaultManager] subpathsAtPath:self.diskPath];
        for (NSString *fileName in filePaths) {
            NSString *fullName = [self.diskPath stringByAppendingPathComponent:fileName];
            NSString *content = [NSString stringWithContentsOfFile:fullName encoding:NSUTF8StringEncoding error:nil];
            [self uploadStackTrack:content traceName:fileName];
#warning todo 删除文件可以放在上传成功之后再删除
            [[NSFileManager defaultManager] removeItemAtPath:fullName error:nil];
        }
    });
}

- (NSString*)trackFileNameWithType:(XCTrackType)type {
    //NSString* uuid = GetHardwareUUID();
    NSDate* now = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString* dateString = [dateFormatter stringFromDate:now];
    
    NSString* fileName = [NSString stringWithFormat:@"%@.%@",dateString, self.labelsForTrackType[type]];
    return fileName;
}

- (void)trackBackgroundTask {
    
}

@end







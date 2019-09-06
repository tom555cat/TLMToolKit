//
//  XCMonitorLog.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "XCMonitorLog.h"
#import "XCMonitorHeader.h"
#import "XCMonitorDataAdapter.h"
#import "XCMonitor.h"

@interface XCMonitorLog ()

@property (nonatomic, strong) NSString *diskPath;

@end

@implementation XCMonitorLog

+ (instancetype)sharedLogger {
    static XCMonitorLog *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XCMonitorLog alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _diskPath = [self makeDiskPath];
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
        if ([dataAdapter respondsToSelector:@selector(log)]) {
            NSDictionary *logMsg = [dataAdapter log];
            NSString *name = logMsg[XCMonitorLogNameKey];
            NSString *content = logMsg[XCMonitorLogContentKey];
            [self storeToDiskWithMessage:content fileName:name];
        }
    }
}

- (NSString *)makeDiskPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *stackTrackDirectory = [paths[0] stringByAppendingPathComponent:@"TLMStackTrack"];
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

- (void)storeToDiskWithMessage:(NSString *)message fileName:(NSString *)fileName {
    NSString *storePath = [self makeStorePathWithFileName:fileName];
    [message writeToFile:storePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}



@end

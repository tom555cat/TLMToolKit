//
//  XCMonitor.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "XCMonitor.h"
#import "XCMonitorDynamicLoader.h"
#import "XCMonitorHeader.h"

@interface XCMonitor ()

@property (nonatomic, strong) XCMonitorConfig *config;

@end

@implementation XCMonitor

+ (void)load {
    @autoreleasepool {
        
        // 在首页viewDidAppear中发出通知  ////UIApplicationDidFinishLaunchingNotification
        // 手动登录时首页会重新加载，也会触发
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            XCMonitorConfig *configuration = [XCMonitorConfig defaultConfiguration];
            XCMonitor *monitor = [XCMonitor monitorWithConfiguration:configuration];
            [XCMonitorDynamicLoader executeFunctionsForKey:XCMonitorModuleStartPhase];
        }];
    }
}

+ (XCMonitor *)sharedMonitor {
    static XCMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XCMonitor alloc] init];
    });
    return instance;
}

+ (XCMonitor *)monitorWithConfiguration:(XCMonitorConfig *)config {
    XCMonitor *monitor = [self sharedMonitor];
    monitor.config = config;
    return monitor;
}

- (XCMonitorUseMode)monitorUseMode {
    return self.config.userMode;
}

@end

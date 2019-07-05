//
//  XCMonitorAlert.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "XCMonitorAlert.h"
#import "XCMonitorHeader.h"
#import "XCMonitorDataAdapter.h"
#import "XCMonitor.h"

@implementation XCMonitorAlert

+ (instancetype)sharedAlert {
    static XCMonitorAlert *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XCMonitorAlert alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
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
        if ([dataAdapter respondsToSelector:@selector(alert)]) {
            NSString *alertMsg = [dataAdapter alert];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"XCMonitor监控提示" message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

@end

//
//  XCMonitor.h
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import <Foundation/Foundation.h>
#import "XCMonitorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCMonitor : NSObject

+ (XCMonitor *)sharedMonitor;

+ (XCMonitor *)monitorWithConfiguration:(XCMonitorConfig *)config;

- (XCMonitorUseMode)monitorUseMode;

//- (instancetype)init;

@end

NS_ASSUME_NONNULL_END

//
//  XCMemoryMonitor.h
//  Pods
//
//  Created by tongleiming on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "XCMonitorDataAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCMemoryMonitor : NSObject <XCMonitorDataAdapter>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

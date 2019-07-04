//
//  XCMonitorConfig.h
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, XCMonitorDataStrategy) {
    /**日志弹窗提示**/
    XCMonitorDataStrategyAlert = 0,
    /**日志记录本地**/
    XCMonitorDataStrategyLog = 1 << 0,
    /**日志记录上报**/
    XCMonitorDataStrategyReport = 1 << 1,
    /**日志记录弹窗+本地记录+上报**/
    XCMonitorDataStrategyAll = (XCMonitorDataStrategyAlert | XCMonitorDataStrategyLog | XCMonitorDataStrategyReport)
};

@interface XCMonitorConfig : NSObject

@end

NS_ASSUME_NONNULL_END

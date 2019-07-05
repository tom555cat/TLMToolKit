//
//  XCMonitorUtil.h
//  Pods
//
//  Created by tongleiming on 2019/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCMonitorUtil : NSObject

// 给定后缀，返回日志名字
+ (NSString*)trackFileNameWithSuffix:(NSString *)suffix;

// 返回堆栈日志
+ (NSString *)trackStackFrames;

@end

NS_ASSUME_NONNULL_END

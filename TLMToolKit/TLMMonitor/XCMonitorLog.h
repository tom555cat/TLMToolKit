//
//  XCMonitorLog.h
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCMonitorLog : NSObject

+ (instancetype)sharedLogger;

/// 将内容保存到本地
/// @param message 保存内容
/// @param fileName 保存文件名
- (void)storeToDiskWithMessage:(NSString *)message fileName:(NSString *)fileName;

@property (nonatomic, readonly) NSString *diskPath;

@end

NS_ASSUME_NONNULL_END

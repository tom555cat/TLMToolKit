//
//  XCMonitorDataAdapter.h
//  Pods
//
//  Created by tongleiming on 2019/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XCMonitorDataAdapter <NSObject>

@optional

- (NSDictionary *)log;

- (NSString *)alert;

- (NSDictionary *)report;

- (void)floatWindow:(NSString *)value;

@end

NS_ASSUME_NONNULL_END

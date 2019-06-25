//
//  XCModuleManager.h
//  Pods
//
//  Created by tongleiming on 2019/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCModuleManager : NSObject

+ (instancetype)sharedManager;

- (void)addModuleInitFuncs:(NSArray *)funcArray forLevel:(NSString *)level;


// 对应阶段
//@"XCStartWillLaunch" : @"LEVEL_A",
//@"XCStartBeforeFirstPageConstruct": @"LEVEL_B",
//@"XCStartAfterFirstPageConstruct": @"LEVEL_C",
//@"XCStartAfterFirstPageRender": @"LEVEL_D"
@property (nonatomic, strong) NSArray *levelArray;
@property (nonatomic, strong) NSMutableDictionary *modInitFuncPtrArrayLevelDic;

@end

NS_ASSUME_NONNULL_END

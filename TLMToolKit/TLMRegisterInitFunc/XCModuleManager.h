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

- (void)addModuleInitFuncs:(NSArray *)funcArray forStage:(NSString *)stage;


// 对应阶段
//@"XCStartWillLaunch" : @"LEVEL_A",
//@"XCStartBeforeFirstPageConstruct": @"LEVEL_B",
//@"XCStartAfterFirstPageConstruct": @"LEVEL_C",
//@"XCStartAfterFirstPageRender": @"LEVEL_D"
@property (nonatomic, strong) NSArray *stageArray;
@property (nonatomic, strong) NSMutableDictionary *modInitFuncPtrArrayStageDic;

@end

NS_ASSUME_NONNULL_END

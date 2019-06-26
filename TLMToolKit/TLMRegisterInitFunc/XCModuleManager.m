//
//  XCModuleManager.m
//  Pods
//
//  Created by tongleiming on 2019/6/24.
//

#import "XCModuleManager.h"

@interface XCModuleManager ()

@end

@implementation XCModuleManager

+ (instancetype)sharedManager {
    static XCModuleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XCModuleManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {        
        self.stageArray = @[
                            @"STAGE_A",
                            @"STAGE_B",
                            @"STAGE_C",
                            @"STAGE_D"
                            ];
        self.modInitFuncPtrArrayStageDic = [NSMutableDictionary dictionary];
        for (NSString *stage in self.stageArray) {
            self.modInitFuncPtrArrayStageDic[stage] = [NSMutableArray array];
        }
    }
    return self;
}

- (void)addModuleInitFuncs:(NSArray *)funcArray forStage:(NSString *)stage {
    NSMutableArray *stageArray = self.modInitFuncPtrArrayStageDic[stage];
    [stageArray addObjectsFromArray:funcArray];
}

@end

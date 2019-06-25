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
        self.levelArray = @[@"LEVEL_A", @"LEVEL_B", @"LEVEL_C"];
        self.modInitFuncPtrArrayLevelDic = [NSMutableDictionary dictionary];
        for (NSString *level in self.levelArray) {
            self.modInitFuncPtrArrayLevelDic[level] = [NSMutableArray array];
        }
    }
    return self;
}

- (void)addModuleInitFuncs:(NSArray *)funcArray forLevel:(NSString *)level {
    NSMutableArray *levelArray = self.modInitFuncPtrArrayLevelDic[level];
    [levelArray addObjectsFromArray:funcArray];
}

@end

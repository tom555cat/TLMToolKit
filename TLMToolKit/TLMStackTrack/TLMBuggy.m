//
//  TLMBuggy.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "TLMBuggy.h"

@implementation TLMBuggy

+ (instancetype)sharedManager {
    static TLMBuggy *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TLMBuggy alloc] init];
    });
    return instance;
}

- (void)reportError:(NSError *)error {
    
}

@end

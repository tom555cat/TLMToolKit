//
//  TLMPerformanceLogger.m
//  Pods
//
//  Created by tongleiming on 2019/6/21.
//

#import "TLMPerformanceLogger.h"

@interface TLMPerformanceLogger ()
{
    int64_t _data[TLMPLSize][2];
    NSUInteger _cookies[TLMPLSize];
}

@property (nonatomic, copy) NSArray<NSString *> *labelsForTags;

@end

@implementation TLMPerformanceLogger

//TLMPLMainFunction = 0,
//TLMPLApplicationDidFinishLaunching,
//TLMPLUpDateBundle,
//TLMPLDoCheckUpdate,
//TLMPLCheckDo,
//TLMPLBundleLoad,

+ (instancetype)sharedLogger {
    static TLMPerformanceLogger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TLMPerformanceLogger alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _labelsForTags = @[
                           @"MainFunction",
                           @"ApplicationDidFinishLaunching",
                           @"UpDateBundle",
                           @"DoCheckUpdate",
                           @"CheckDo",
                           @"BundleLoad"
                           ];
    }
    return self;
}

- (void)markStartForTag:(TLMPLTag)tag
{
//#if RCT_PROFILE
//    if (RCTProfileIsProfiling()) {
//        NSString *label = _labelsForTags[tag];
//        _cookies[tag] = RCTProfileBeginAsyncEvent(RCTProfileTagAlways, label, nil);
//    }
//#endif
    _data[tag][0] = CACurrentMediaTime() * 1000;
    _data[tag][1] = 0;
}


- (void)markStopForTag:(TLMPLTag)tag
{
//#if RCT_PROFILE
//    if (RCTProfileIsProfiling()) {
//        NSString *label =_labelsForTags[tag];
//        RCTProfileEndAsyncEvent(RCTProfileTagAlways, @"native", _cookies[tag], label, @"RCTPerformanceLogger");
//    }
//#endif
    if (_data[tag][0] != 0 && _data[tag][1] == 0) {
        _data[tag][1] = CACurrentMediaTime() * 1000;
    } else {
        //RCTLogInfo(@"Unbalanced calls start/end for tag %li", (unsigned long)tag);
        NSLog(@"--- TLMPerformanceLogger: Unbalanced calls start/end for tag %li", (unsigned long)tag);
    }
}

- (void)setValue:(int64_t)value forTag:(TLMPLTag)tag
{
    _data[tag][0] = 0;
    _data[tag][1] = value;
}

- (void)addValue:(int64_t)value forTag:(TLMPLTag)tag
{
    _data[tag][0] = 0;
    _data[tag][1] += value;
}

- (void)appendStartForTag:(TLMPLTag)tag
{
    _data[tag][0] = CACurrentMediaTime() * 1000;
}

- (void)appendStopForTag:(TLMPLTag)tag
{
    if (_data[tag][0] != 0) {
        _data[tag][1] += CACurrentMediaTime() * 1000 - _data[tag][0];
        _data[tag][0] = 0;
    } else {
        //RCTLogInfo(@"Unbalanced calls start/end for tag %li", (unsigned long)tag);
        NSLog(@"--- TLMPerformanceLogger: Unbalanced calls start/end for tag %li", (unsigned long)tag);
    }
}

- (NSArray<NSNumber *> *)valuesForTags
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger index = 0; index < TLMPLSize; index++) {
        [result addObject:@(_data[index][0])];
        [result addObject:@(_data[index][1])];
    }
    return result;
}

- (int64_t)durationForTag:(TLMPLTag)tag
{
    return _data[tag][1] - _data[tag][0];
}

- (int64_t)valueForTag:(TLMPLTag)tag
{
    return _data[tag][1];
}


@end

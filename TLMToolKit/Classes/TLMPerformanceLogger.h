//
//  TLMPerformanceLogger.h
//  Pods
//
//  Created by tongleiming on 2019/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TLMPLTag) {
    TLMPLMainFunction = 0,
    TLMPLSize
};

@interface TLMPerformanceLogger : NSObject

/**
 * Starts measuring a metric with the given tag.
 * Overrides previous value if the measurement has been already started.
 * If RCTProfile is enabled it also begins appropriate async event.
 * All work is scheduled on the background queue so this doesn't block current thread.
 */
- (void)markStartForTag:(TLMPLTag)tag;

/**
 * Stops measuring a metric with given tag.
 * Checks if RCTPerformanceLoggerStart() has been called before
 * and doesn't do anything and log a message if it hasn't.
 * If RCTProfile is enabled it also ends appropriate async event.
 * All work is scheduled on the background queue so this doesn't block current thread.
 */
- (void)markStopForTag:(TLMPLTag)tag;

/**
 * Sets given value for a metric with given tag.
 * All work is scheduled on the background queue so this doesn't block current thread.
 */
- (void)setValue:(int64_t)value forTag:(TLMPLTag)tag;

/**
 * Adds given value to the current value for a metric with given tag.
 * All work is scheduled on the background queue so this doesn't block current thread.
 */
- (void)addValue:(int64_t)value forTag:(TLMPLTag)tag;

/**
 * Starts an additional measurement for a metric with given tag.
 * It doesn't override previous measurement, instead it'll append a new value
 * to the old one.
 * All work is scheduled on the background queue so this doesn't block current thread.
 */
- (void)appendStartForTag:(TLMPLTag)tag;

/**
 * Stops measurement and appends the result to the metric with given tag.
 * Checks if RCTPerformanceLoggerAppendStart() has been called before
 * and doesn't do anything and log a message if it hasn't.
 * All work is scheduled on the background queue so this doesn't block current thread.
 */
- (void)appendStopForTag:(TLMPLTag)tag;

/**
 * Returns an array with values for all tags.
 * Use TLMPLTag to go over the array, there's a pair of values
 * for each tag: start and stop (with indexes 2 * tag and 2 * tag + 1).
 */
- (NSArray<NSNumber *> *)valuesForTags;

/**
 * Returns a duration in ms (stop_time - start_time) for given TLMPLTag.
 */
- (int64_t)durationForTag:(TLMPLTag)tag;

/**
 * Returns a value for given TLMPLTag.
 */
- (int64_t)valueForTag:(TLMPLTag)tag;

/**
 * Returns an array with values for all tags.
 * Use TLMPLTag to go over the array.
 */
- (NSArray<NSString *> *)labelsForTags;

@end

NS_ASSUME_NONNULL_END

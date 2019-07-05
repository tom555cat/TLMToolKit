//
//  XCMonitorUtil.m
//  Pods
//
//  Created by tongleiming on 2019/7/5.
//

#import "XCMonitorUtil.h"
#import <CrashReporter/CrashReporter.h>

@implementation XCMonitorUtil

+ (NSString*)trackFileNameWithSuffix:(NSString *)suffix {
    //NSString* uuid = GetHardwareUUID();
    NSDate* now = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString* dateString = [dateFormatter stringFromDate:now];
    
    NSString* fileName = [NSString stringWithFormat:@"%@.%@",dateString, suffix];
    return fileName;
}

+ (NSString *)trackStackFrames {
    NSData *stackFramesData = [[[PLCrashReporter alloc]
                        initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
    PLCrashReport *stackFramesReport = [[PLCrashReport alloc] initWithData:stackFramesData error:NULL];
    NSString *stackFramesStr = [PLCrashReportTextFormatter stringValueForCrashReport:stackFramesReport withTextFormat:PLCrashReportTextFormatiOS];
    return stackFramesStr;
}

@end

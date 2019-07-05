//
//  XCMemoryMonitor.m
//  Pods
//
//  Created by tongleiming on 2019/7/2.
//

#import "XCMemoryMonitor.h"
#import <malloc/malloc.h>
#import <mach/mach_host.h>
#import <mach/task.h>
//#import "Buggy.h"
#import <FBAllocationTracker/FBAllocationTracker.h>
#import "XCMonitorHeader.h"
#import "XCMonitorUtil.h"
#import "XCMonitorDynamicLoader.h"

RAM_FUNCTION_EXPORT(XCMonitor)() {
    [XCMemoryMonitor sharedInstance];
}

@interface XCMemoryMonitor ()

@property (nonatomic, copy) NSString *memoryLog;
@property (nonatomic, copy) NSString *memoryLogFileName;

@end

@implementation XCMemoryMonitor

+ (instancetype)sharedInstance
{
    static XCMemoryMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XCMemoryMonitor alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
        [[FBAllocationTrackerManager sharedManager] enableGenerations];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)memorySummary
{
    NSArray *summarys = [[FBAllocationTrackerManager sharedManager] currentAllocationSummary];
    NSMutableArray *filtedSummary = [[NSMutableArray alloc] init];
    for (FBAllocationTrackerSummary *summary in summarys) {
        if (summary.aliveObjects > 0) {
            [filtedSummary addObject:summary];
        }
    }
    summarys = [filtedSummary copy];
    summarys = [summarys sortedArrayUsingComparator:^NSComparisonResult(FBAllocationTrackerSummary *  _Nonnull obj1, FBAllocationTrackerSummary *  _Nonnull obj2) {
        return [@(obj2.aliveObjects * obj2.instanceSize) compare:@(obj1.aliveObjects *obj1.instanceSize)];
    }];
    if (summarys.count > 30) {
        summarys = [summarys subarrayWithRange:NSMakeRange(0, 30)];
    }
    NSMutableArray *summaryReports = [[NSMutableArray alloc] init];
    for (FBAllocationTrackerSummary *summary in summarys) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"className"] = summary.className;
        dic[@"instanceSize"] = @(summary.instanceSize);
        dic[@"aliveObjects"] = @(summary.aliveObjects);
        [summaryReports addObject:dic];
    }
    
    return [summaryReports copy];
}

- (void)didReceiveMemoryWarning
{
    double maxMemory = [self appMaxMemory];
    double usageMemory = [self appUsageMemory];
    double footprint = [self appFootPrint];
//    NSError *error = [NSError errorWithDomain:@"UIApplicationDidReceiveMemoryWarningNotification" code:6666 userInfo:@{NSLocalizedDescriptionKey:UIApplicationDidReceiveMemoryWarningNotification,@"appMaxMemory":@(maxMemory),@"appUsageMemory":@(usageMemory),@"appFootPrint":@(footprint),@"extra":[self memorySummary]}];
//    [Buggy reportError:error];
    NSDictionary *memoryInfoDic = @{
                                    @"appMaxMemory":@(maxMemory),
                                    @"appUsageMemory":@(usageMemory),
                                    @"appFootPrint":@(footprint),
                                    @"extra":[self memorySummary]
                                    };
    self.memoryLog = [memoryInfoDic description];
    self.memoryLogFileName = [XCMonitorUtil trackFileNameWithSuffix:@"memoryWarning"];
    [[NSNotificationCenter defaultCenter] postNotificationName:XCMonitorNotification object:nil];
}

- (double)appMaxMemory
{
    mach_task_basic_info_data_t taskInfo;
    unsigned infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (double)appUsageMemory
{
    mach_task_basic_info_data_t taskInfo;
    unsigned infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size_max / 1024.0 / 1024.0;
}

- (double)appFootPrint
{
    task_vm_info_data_t taskInfo;
    unsigned infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.phys_footprint / 1024.0 / 1024.0 / 1024.0 / 1024.0;
}

#pragma mark - XCMonitorDataAdapter

- (NSDictionary *)log {
    return @{
             XCMonitorLogNameKey: self.memoryLogFileName?:@"memoryWarning",
             XCMonitorLogContentKey: self.memoryLog?:@""
            };
}

- (NSString *)alert {
    return @"发生内存警告!";
}

- (NSDictionary *)report {
    return @{
             XCMonitorReportNameKey: self.memoryLogFileName?:@"memoryWarning",
             XCMonitorReportContentKey: self.memoryLog?:@""
            };
}

@end

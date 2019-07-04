//
//  TLMMemoryMonitor.m
//  Pods
//
//  Created by tongleiming on 2019/7/2.
//

#import "TLMMemoryMonitor.h"
#import <malloc/malloc.h>
#import <mach/mach_host.h>
#import <mach/task.h>
//#import "Buggy.h"
#import <FBAllocationTracker/FBAllocationTracker.h>

@implementation TLMMemoryMonitor

+ (instancetype)sharedInstance
{
    static TLMMemoryMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TLMMemoryMonitor alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
        [[FBAllocationTrackerManager sharedManager] enableGenerations];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
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
    NSError *error = [NSError errorWithDomain:@"UIApplicationDidReceiveMemoryWarningNotification" code:6666 userInfo:@{NSLocalizedDescriptionKey:UIApplicationDidReceiveMemoryWarningNotification,@"appMaxMemory":@(maxMemory),@"appUsageMemory":@(usageMemory),@"appFootPrint":@(footprint),@"extra":[self memorySummary]}];
//    [Buggy reportError:error];
#warning todo 上报信息
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

@end

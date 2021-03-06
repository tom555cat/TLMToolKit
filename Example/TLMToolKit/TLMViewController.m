//
//  TLMViewController.m
//  TLMToolKit
//
//  Created by tongleiming1989@sina.com on 06/21/2019.
//  Copyright (c) 2019 tongleiming1989@sina.com. All rights reserved.
//

#import "TLMViewController.h"
#import "XCDynamicLoader.h"
#import "XCStackTrack.h"
#import <FBAllocationTracker/FBAllocationTracker.h>
#import "TLMUILagViewController.h"
#import "XCMonitorSettingViewController.h"
#import "TLMNetworkMetricsViewController.h"

@interface TLMViewController ()

@end

@implementation TLMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[[TLMStackTrack sharedManager] trackStack];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"cold start" message:@"cold start" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    [alert show];
    
    NSObject *t = [[NSObject alloc] init];
    
//    for (NSInteger i = 0; i < 1000000; i++) {
//        NSLog(@"123");
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        for (NSInteger i = 0; i < 1000000; i++) {
//            NSLog(@"123");
//        }
    });
    
    NSLog(@"%@", [self memorySummary]);
    
}

- (IBAction)btnClicked:(id)sender {
    TLMUILagViewController *vc = [[TLMUILagViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)gotoMonitorSetting:(id)sender {
    XCMonitorSettingViewController *vc = [[XCMonitorSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)networkMetrics:(id)sender {
    TLMNetworkMetricsViewController *vc = [[TLMNetworkMetricsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [XCDynamicLoader executeFunctionsForKey:@"STAGE_C"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

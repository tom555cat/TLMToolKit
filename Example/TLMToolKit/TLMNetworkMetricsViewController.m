//
//  TLMNetworkMetricsViewController.m
//  TLMToolKit
//
//  Created by tom555cat on 2019/8/17.
//  Copyright © 2019年 tongleiming1989@sina.com. All rights reserved.
//

#import "TLMNetworkMetricsViewController.h"
#import "AFNetworking.h"

@interface TLMNetworkMetricsViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@end

@implementation TLMNetworkMetricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"completed!");
    }];
    
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didFinishCollectingMetrics:(nonnull NSURLSessionTaskMetrics *)metrics {
    NSLog(@"%@", task);
    
    // NSURLSessionTaskMetrics::taskInterval
    NSLog(@"---------- taskInterval ----------");
    NSLog(@"%@", metrics.taskInterval);
    
    // NSURLSessionTaskMetrics::redirectCount
    NSLog(@"---------- redirectCount ----------");
    NSLog(@"%ld", metrics.redirectCount);
    
    // NSURLSessionTaskMetrics::transactionMetrics
    NSLog(@"---------- transactionMetrics ----------");
    for (NSURLSessionTaskTransactionMetrics *taskTransactionMetric in metrics.transactionMetrics) {
        NSLog(@"---------- NSURLSessionTaskTransactionMetrics ----------");
        NSLog(@"%@", taskTransactionMetric);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  XCMonitorReport.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "XCMonitorReport.h"
#import <AFNetworking.h>

@implementation XCMonitorReport

- (void)uploadStackTrack:(NSString *)traceContent traceName:(NSString *)traceName {
    if (traceContent.length <= 0 || traceName.length <= 0) {
        return;
    }
    NSString *URLString = @"http://10.36.32.247:3000/stacklog";
    NSDictionary *parameters = @{@"name": traceName, @"content": traceContent};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    if (error) {
                                                        NSLog(@"Error: %@", error);
                                                    } else {
                                                        NSLog(@"%@ %@", response, responseObject);
                                                    }
                                                }];
    [dataTask resume];
}

@end

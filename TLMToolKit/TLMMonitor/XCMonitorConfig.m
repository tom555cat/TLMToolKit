//
//  XCMonitorConfig.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "XCMonitorConfig.h"

@implementation XCMonitorConfig

+ (XCMonitorConfig *)defaultConfiguration {
    XCMonitorConfig *config = [[XCMonitorConfig alloc] init];
    config.userMode = XCMonitorUseInDevelop;
    return config;
}

@end

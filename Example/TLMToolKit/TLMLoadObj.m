//
//  TLMLoadObj.m
//  TLMToolKit_Example
//
//  Created by tongleiming on 2019/6/24.
//  Copyright © 2019 tongleiming1989@sina.com. All rights reserved.
//

#import "TLMLoadObj.h"
#import "XCDynamicLoader.h"

char * LEVEL_A = "LEVEL_A";
char * LEVEL_B = "LEVEL_B";
char * LEVEL_C = "LEVEL_C";

XCDYML_FUNCTIONS_EXPORT_BEGIN(LEVEL_A)
NSLog(@"=====LEVEL_3_1==========");
XCDYML_FUNCTIONS_EXPORT_END(LEVEL_A)

@implementation TLMLoadObj

@end

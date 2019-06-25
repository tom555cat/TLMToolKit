//
//  TLMViewController.m
//  TLMToolKit
//
//  Created by tongleiming1989@sina.com on 06/21/2019.
//  Copyright (c) 2019 tongleiming1989@sina.com. All rights reserved.
//

#import "TLMViewController.h"
#import "XCDynamicLoader.h"

XC_FUNCTION_EXPORT(LEVLE_A)(){
    NSLog(@"level A, ViewController");
}
XC_FUNCTION_EXPORT(LEVLE_B)(){
    NSLog(@"level B, ViewController");
}
XC_FUNCTION_EXPORT(LEVLE_C)(){
    NSLog(@"level C, ViewController");
}
XC_FUNCTION_EXPORT(LEVLE_D)(){
    NSLog(@"level D, ViewController");
}

@interface TLMViewController ()

@end

@implementation TLMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  TLMViewController.m
//  TLMToolKit
//
//  Created by tongleiming1989@sina.com on 06/21/2019.
//  Copyright (c) 2019 tongleiming1989@sina.com. All rights reserved.
//

#import "TLMViewController.h"
#import "XCDynamicLoader.h"

@interface TLMViewController ()

@end

@implementation TLMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

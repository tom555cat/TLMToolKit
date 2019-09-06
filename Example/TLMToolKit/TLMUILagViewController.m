//
//  TLMUILagViewController.m
//  TLMToolKit_Example
//
//  Created by tongleiming on 2019/7/8.
//  Copyright © 2019 tongleiming1989@sina.com. All rights reserved.
//

#import "TLMUILagViewController.h"
#import "TLMUILageTableViewCell.h"

@interface TLMUILagViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TLMUILagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TLMUILageTableViewCell" bundle:nil] forCellReuseIdentifier:@"TLMUILageTableViewCell"];
    [self.view addSubview:self.tableView];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLMUILageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMUILageTableViewCell"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [cell configImage1:image];
    [cell configImage2:image];
    [cell configImage3:image];
//    for (NSInteger i = 0; i < 10000; i++) {
//        NSLog(@"wait");
//    }
    return cell;
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

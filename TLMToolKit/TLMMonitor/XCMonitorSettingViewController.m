//
//  XCMonitorSettingViewController.m
//  Pods
//
//  Created by tongleiming on 2019/7/9.
//

#import "XCMonitorSettingViewController.h"

typedef void(^CellSelectionBlk)(void);

@interface XCMonitorSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *actionDictionary;

@end

@implementation XCMonitorSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.actionDictionary = [NSMutableDictionary dictionary];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
        default:
            break;
    }
    return rows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self generateIdentifier:indexPath];
    CellSelectionBlk blk = self.actionDictionary[identifier];
    if (blk) {
        blk();
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = [self simulateUILagCellTableView:tableView forRowAtIndexPath:indexPath];
            break;
            
        case 1:
            cell = [self uploadLocalLogsCellTableView:tableView forRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
    return cell;
}

- (UITableViewCell *)simulateUILagCellTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self generateIdentifier:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"模拟卡顿";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.actionDictionary[identifier] = ^{
        NSLog(@"进入卡顿模拟");
    };
    
    return cell;
}

- (UITableViewCell *)uploadLocalLogsCellTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self generateIdentifier:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"导出本地日志到服务器";
    return cell;
}

- (NSString *)generateIdentifier:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%ld_%ld", indexPath.section, indexPath.row];
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

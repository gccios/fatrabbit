//
//  FRMyViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyViewController.h"
#import "FRUserHeaderView.h"
#import "FRMenuTableViewCell.h"
#import "FROrderPageViewController.h"
#import "FRAddressViewController.h"
#import "FRUserAdviceViewController.h"
#import "FRSettingViewController.h"
#import "FRLoginViewController.h"
#import "UserManager.h"

@interface FRMyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * myTableView;

@property (nonatomic, strong) FRUserHeaderView * userHeaderView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createDataSource];
    [self createViews];
}

- (void)createDataSource
{
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_MyAccount],
                                 [[MyMenuModel alloc] initWithType:MyMenuType_MyAddress]]];
    [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_ApplyRegister]]];
    [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_Advice],
                                 [[MyMenuModel alloc] initWithType:MyMenuType_Setting]]];
}

- (void)userInfoDidClicked
{
    FRLoginViewController * login = [[FRLoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)createViews
{
    self.navigationItem.title = @"我的";
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[FRMenuTableViewCell class] forCellReuseIdentifier:@"FRMenuTableViewCell"];
    [self.myTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self createMyTableHeader];
}

- (void)createMyTableHeader
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.userHeaderView = [[FRUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 200 * scale)];
    
    __weak typeof(self) weakSelf = self;
    self.userHeaderView.userInfoDidClickedHandle = ^{
        [weakSelf userInfoDidClicked];
    };
    
    self.myTableView.tableHeaderView = self.userHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * data = [self.dataSource objectAtIndex:indexPath.section];
    MyMenuModel * model = [data objectAtIndex:indexPath.row];
    
    if (model.type == MyMenuType_MyAddress) {
        FRAddressViewController * address = [[FRAddressViewController alloc] init];
        [self.navigationController pushViewController:address animated:YES];
    }else if (model.type == MyMenuType_Advice) {
        FRUserAdviceViewController * advice = [[FRUserAdviceViewController alloc] init];
        [self.navigationController pushViewController:advice animated:YES];
    }else if (model.type == MyMenuType_Setting) {
        FRSettingViewController * setting = [[FRSettingViewController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }else{
        FROrderPageViewController * order = [[FROrderPageViewController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * data = [self.dataSource objectAtIndex:section];
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMenuTableViewCell" forIndexPath:indexPath];
    
    NSArray * data = [self.dataSource objectAtIndex:indexPath.section];
    MyMenuModel * model = [data objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 60 * scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;//把高度设置很小，效果可以看成footer的高度等于0
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

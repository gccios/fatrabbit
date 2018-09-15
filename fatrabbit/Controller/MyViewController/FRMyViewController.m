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
#import "FRMyInfoViewController.h"
#import "FRMyServiceViewController.h"
#import "UserManager.h"
#import "FRMyAccountViewController.h"
#import "FRMyCollectViewController.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePageWithUserLoginStatus) name:FRUserLoginStatusDidChange object:nil];
}

- (void)updatePageWithUserLoginStatus
{
    [self createDataSource];
    [self.myTableView reloadData];
}


- (void)createDataSource
{
    [self.dataSource removeAllObjects];
    
    if ([UserManager shareManager].isLogin && [UserManager shareManager].is_provider == 0) {
        
        [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_MyAccount],
                                     [[MyMenuModel alloc] initWithType:MyMenuType_MyAddress]]];
        [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_MyIntel],
                                     [[MyMenuModel alloc] initWithType:MyMenuType_MyExample],
                                     [[MyMenuModel alloc] initWithType:MyMenuType_MyService],
                                     [[MyMenuModel alloc] initWithType:MyMenuType_MyGetOrder]]];
        [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_Advice],
                                     [[MyMenuModel alloc] initWithType:MyMenuType_Setting]]];
        
    }else{
        
        [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_MyAccount],
                                     [[MyMenuModel alloc] initWithType:MyMenuType_MyAddress]]];
        [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_ApplyRegister]]];
        [self.dataSource addObject:@[[[MyMenuModel alloc] initWithType:MyMenuType_Advice],
                                     [[MyMenuModel alloc] initWithType:MyMenuType_Setting]]];
        
    }
}

- (void)userInfoDidClicked
{
    if ([UserManager shareManager].isLogin) {
        FRMyInfoViewController * info = [[FRMyInfoViewController alloc] init];
        [self.navigationController pushViewController:info animated:YES];
    }else{
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)headerMenuDidSelect:(FRUserHeaderMenuModel *)model
{
    if (model.type == FRUserHeaderMenuType_Order) {
        FROrderPageViewController * order = [[FROrderPageViewController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }else if (model.type == FRUserHeaderMenuType_Collect) {
        FRMyCollectViewController * collect = [[FRMyCollectViewController alloc] init];
        [self.navigationController pushViewController:collect animated:YES];
    }else if (model.type == FRUserHeaderMenuType_Need) {
        FROrderPageViewController * order = [[FROrderPageViewController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }
}

- (void)createViews
{
    self.navigationItem.title = @"我的";
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.myTableView registerClass:[FRMenuTableViewCell class] forCellReuseIdentifier:@"FRMenuTableViewCell"];
    [self.myTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, 30 * kMainBoundsWidth / 375.f, 0);
    
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
    self.userHeaderView.userHeaderMenuDidClickedHandle = ^(FRUserHeaderMenuModel *model) {
        [weakSelf headerMenuDidSelect:model];
    };
    
    self.myTableView.tableHeaderView = self.userHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * data = [self.dataSource objectAtIndex:indexPath.section];
    MyMenuModel * model = [data objectAtIndex:indexPath.row];
    
    if (![UserManager shareManager].isLogin) {
        if (model.type == MyMenuType_Setting) {
            FRSettingViewController * setting = [[FRSettingViewController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
        }else{
            FRLoginViewController * login = [[FRLoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
    
    if (model.type == MyMenuType_MyAddress) {
        FRAddressViewController * address = [[FRAddressViewController alloc] init];
        [self.navigationController pushViewController:address animated:YES];
    }else if (model.type == MyMenuType_Advice) {
        FRUserAdviceViewController * advice = [[FRUserAdviceViewController alloc] init];
        [self.navigationController pushViewController:advice animated:YES];
    }else if (model.type == MyMenuType_Setting) {
        FRSettingViewController * setting = [[FRSettingViewController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }else if (model.type == MyMenuType_MyAccount) {
        FRMyAccountViewController * account = [[FRMyAccountViewController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
    }else if (model.type == MyMenuType_MyService) {
        FRMyServiceViewController * service = [[FRMyServiceViewController alloc] init];
        [self.navigationController pushViewController:service animated:YES];
    }else if (model.type == MyMenuType_MyGetOrder) {
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;//把高度设置很小，效果可以看成footer的高度等于0
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;//把高度设置很小，效果可以看成footer的高度等于0
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

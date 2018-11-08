//
//  FRSettingViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRSettingViewController.h"
#import "FRSettingTableViewCell.h"
#import "UserManager.h"

@interface FRSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    [self createDataSource];
    [self createViews];
}

- (void)createDataSource
{
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObject:[[FRSettingModel alloc] initWithType:FRSettingType_Cache]];
    [self.dataSource addObject:[[FRSettingModel alloc] initWithType:FRSettingType_Version]];
    [self.dataSource addObject:[[FRSettingModel alloc] initWithType:FRSettingType_AboutUs]];
    if ([UserManager shareManager].isLogin) {
        [self.dataSource addObject:[[FRSettingModel alloc] initWithType:FRSettingType_LogOut]];
    }
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRSettingTableViewCell class] forCellReuseIdentifier:@"FRSettingTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRSettingModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == FRSettingType_Cache) {
        [FRApplicatinInfoTool clearApplicationCache:^{
            [self createDataSource];
            [self.tableView reloadData];
        }];
    }else if (model.type == FRSettingType_LogOut) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要退出当前登录账号？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UserManager shareManager] logOut];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:cancleAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRSettingTableViewCell" forIndexPath:indexPath];
    
    FRSettingModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 60 * scale;
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

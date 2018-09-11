//
//  FRMyAccountViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyAccountViewController.h"
#import "FRMyAccountTableViewCell.h"

@interface FRMyAccountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的账户";
    [self createDataSource];
    [self createViews];
}

- (void)createDataSource
{
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObject:[[FRMyAccountModel alloc] initWithType:FRMyAccountType_Money]];
    [self.dataSource addObject:[[FRMyAccountModel alloc] initWithType:FRMyAccountType_Point]];
    [self.dataSource addObject:[[FRMyAccountModel alloc] initWithType:FRMyAccountType_Invoice]];
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRMyAccountTableViewCell class] forCellReuseIdentifier:@"FRMyAccountTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyAccountModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == FRMyAccountType_Invoice) {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyAccountTableViewCell" forIndexPath:indexPath];
    
    FRMyAccountModel * model = [self.dataSource objectAtIndex:indexPath.row];
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

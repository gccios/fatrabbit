//
//  FRAccountPointsViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/25.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAccountPointsViewController.h"
#import "FRMyAccountMoneyCell.h"
#import "FRUserAccountRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "UserManager.h"

@interface FRAccountPointsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) CGFloat points;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRAccountPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestBalance];
    [self createViews];
}

- (void)requestBalance
{
    FRUserAccountRequest * request = [[FRUserAccountRequest alloc] initWithPoints];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            self.points = [[data objectForKey:@"points"] floatValue];
            [UserManager shareManager].points = self.points;
            NSArray * logs = [data objectForKey:@"logs"];
            self.dataSource = [FRMyPointsModel mj_objectArrayWithKeyValuesArray:logs];
            [self createViews];
            [[NSNotificationCenter defaultCenter] postNotificationName:FRUserLoginStatusDidChange object:nil];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络连接失败"];
        
    }];
}

- (void)createViews
{
    self.navigationItem.title = @"积分";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50 * scale;
    [self.tableView registerClass:[FRMyAccountMoneyCell class] forCellReuseIdentifier:@"FRMyAccountMoneyCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 110 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIView * balanceView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:balanceView];
    [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(50 * scale);
    }];
    
    UILabel * moneyTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    moneyTipLabel.text = @"积分";
    [balanceView addSubview:moneyTipLabel];
    [moneyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel * moneyLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentRight];
    moneyLabel.text = [NSString stringWithFormat:@"%.2lf", self.points];
    [balanceView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(balanceView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    UIView * leftTipView = [[UIView alloc] initWithFrame:CGRectZero];
    leftTipView.backgroundColor = KThemeColor;
    [headerView addSubview:leftTipView];
    [leftTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(22 * scale);
        make.width.mas_equalTo(3 * scale);
        make.bottom.mas_equalTo(-5 * scale);
    }];
    
    UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    tipLabel.text = @"积分明细";
    [headerView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftTipView);
        make.left.mas_equalTo(leftTipView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyAccountMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyAccountMoneyCell" forIndexPath:indexPath];
    
    FRMyPointsModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithPointsModel:model];
    
    return cell;
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

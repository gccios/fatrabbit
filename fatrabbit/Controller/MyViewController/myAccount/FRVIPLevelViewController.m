//
//  FRVIPLevelViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRVIPLevelViewController.h"
#import "FRVIPLevelTableViewCell.h"
#import "FRVIPRequest.h"

@interface FRVIPLevelViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRVIPLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"VIP权益";
    
    [self requestVIPLevelList];
}

- (void)requestVIPLevelList
{
    FRVIPRequest * request = [[FRVIPRequest alloc] initWithVIPLevelList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            self.dataSource = [FRVIPLevelModel mj_objectArrayWithKeyValuesArray:data];
            [self createViews];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50 * scale;
    [self.tableView registerClass:[FRVIPLevelTableViewCell class] forCellReuseIdentifier:@"FRVIPLevelTableViewCell"];
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
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 90 * scale)];
    UIView * tipLineView = [[UIView alloc] initWithFrame:CGRectZero];
    tipLineView.backgroundColor = KThemeColor;
    [headerView addSubview:tipLineView];
    [tipLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(3 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    tipLabel.text = @"VIP级别说明";
    [headerView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipLineView);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(tipLineView.mas_right).offset(10 * scale);
    }];
    
    UILabel * levelLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    levelLabel.text = @"级别";
    [headerView addSubview:levelLabel];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20 * scale);
        make.height.mas_equalTo(20 * scale);
        make.centerX.mas_equalTo(- kMainBoundsWidth/2.f + 50 * scale);
    }];
    
    UILabel * pointLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    pointLabel.text = @"消费额";
    [headerView addSubview:pointLabel];
    [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20 * scale);
        make.centerY.mas_equalTo(levelLabel);
    }];
    
    UILabel * discountLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    discountLabel.text = @"商城折扣";
    [headerView addSubview:discountLabel];
    [discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(levelLabel);
        make.height.mas_equalTo(20 * scale);
        make.centerX.mas_equalTo(kMainBoundsWidth/2.f - 60 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth-30 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRVIPLevelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRVIPLevelTableViewCell" forIndexPath:indexPath];
    
    FRVIPLevelModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
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

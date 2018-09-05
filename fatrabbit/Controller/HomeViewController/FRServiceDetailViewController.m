//
//  FRServiceDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRServiceDetailViewController.h"
#import "FRServiceTableViewCell.h"
#import <SDCycleScrollView.h>

@interface FRServiceDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) UITableView * tableView;

//头视图展示信息
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * favorableLabel;
@property (nonatomic, strong) UILabel * dealLabel;

@end

@implementation FRServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRServiceTableViewCell class] forCellReuseIdentifier:@"FRServiceTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kStatusBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 485 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:@[@"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg"]];
    self.bannerView.autoScrollTimeInterval = 3.f;
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = @"测试金额";
    [headerView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.titleLabel.text = @"测试标题测试标题测试标题";
    [headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.detailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = @"测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容";
    [headerView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_lessThanOrEqualTo(60 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(70 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.logoImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.logoImageView.backgroundColor = [UIColor greenColor];
    [headerView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(70 * scale);
        make.width.mas_equalTo(120 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"测试标题测试标题测试标题测试标题测试标题测试标题";
    [headerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView).offset(5 * scale);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 160 * scale);
    }];
    
    self.favorableLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.favorableLabel.text = @"测试好评率";
    [headerView addSubview:self.favorableLabel];
    [self.favorableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.logoImageView).offset(-5 * scale);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(10 * scale);
    }];
    
    self.dealLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.dealLabel.text = @"测试成交10单";
    [headerView addSubview:self.dealLabel];
    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.logoImageView).offset(-5 * scale);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.favorableLabel.mas_right).offset(15 * scale);
    }];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(15 * scale);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    UIView * colorLineView = [[UIView alloc] initWithFrame:CGRectZero];
    colorLineView.backgroundColor = KThemeColor;
    [headerView addSubview:colorLineView];
    [colorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5 * scale);
        make.left.mas_equalTo(20 * scale);
        make.width.mas_equalTo(3 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * caseLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    caseLabel.text = @"相关案例";
    [headerView addSubview:caseLabel];
    [caseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(colorLineView);
        make.left.mas_equalTo(colorLineView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRServiceTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * kMainBoundsWidth / 375.f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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

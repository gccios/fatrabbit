//
//  FRServiceDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRServiceDetailViewController.h"
#import "FRExampleTableViewCell.h"
#import <SDCycleScrollView.h>
#import "FRServiceRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import <UIImageView+WebCache.h>
#import "LookImageViewController.h"
#import "FRServiceBuyViewController.h"
#import "FRCollectRequest.h"
#import "FRExampleViewController.h"
#import "FRLoginViewController.h"
#import "UserManager.h"

@interface FRServiceDetailViewController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) FRMySeriviceModel * seriviceModel;
@property (nonatomic, strong) UIButton * backButton;

//头视图展示信息
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * favorableLabel;
@property (nonatomic, strong) UILabel * dealLabel;

@property (nonatomic, strong) UIButton * collectButton;

@end

@implementation FRServiceDetailViewController

- (instancetype)initWithSeriviceModel:(FRMySeriviceModel *)model
{
    if (self = [super init]) {
        self.seriviceModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FRServiceRequest * request = [[FRServiceRequest alloc] initDetailWithSeriviceID:self.seriviceModel.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            [self.seriviceModel mj_setKeyValues:data];
            [self createViews];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
    }];
    
    self.backButton = [FRCreateViewTool createButtonWithFrame:CGRectMake(10, 20, 30, 30) font:kPingFangRegular(10) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [self.backButton setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(backButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)contanctButtonDidClicked
{
    NSMutableString  *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.seriviceModel.mobile];
    
    if (@available(iOS 10.0, *)) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)collectButtonDidClicked
{
    [FRCollectRequest cancelRequest];
    if (self.seriviceModel.collect_id == 0) {
        FRCollectRequest * request = [[FRCollectRequest alloc] initWithAddServiceID:self.seriviceModel.cid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            if (KIsDictionary(response)) {
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    self.seriviceModel.collect_id = [[data objectForKey:@"collect_id"] integerValue];
                }
            }
            [self reloadCollectStatus];
            [MBProgressHUD showTextHUDWithText:@"收藏成功"];
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [MBProgressHUD showTextHUDWithText:@"操作失败"];
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
    }else{
        FRCollectRequest * request = [[FRCollectRequest alloc] initWithRemoveID:self.seriviceModel.collect_id];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            self.seriviceModel.collect_id = 0;
            [self reloadCollectStatus];
            [MBProgressHUD showTextHUDWithText:@"取消收藏"];
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [MBProgressHUD showTextHUDWithText:@"操作失败"];
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
    }
}

- (void)reloadCollectStatus
{
    if (self.seriviceModel.collect_id != 0) {
        [self.collectButton setImage:[UIImage imageNamed:@"xinxinyes"] forState:UIControlStateNormal];
    }else{
        [self.collectButton setImage:[UIImage imageNamed:@"xinxinno"] forState:UIControlStateNormal];
    }
}

- (void)buyButtonDidClicked
{
    if (![UserManager shareManager].isLogin) {
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    FRServiceBuyViewController * buy = [[FRServiceBuyViewController alloc] initWithModel:self.seriviceModel];
    [self.navigationController pushViewController:buy animated:YES];
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRExampleTableViewCell class] forCellReuseIdentifier:@"FRExampleTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kStatusBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    [self createTableHeaderView];
    
    UIButton * contanctButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    contanctButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [self.view addSubview:contanctButton];
    [contanctButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    [contanctButton addTarget:self action:@selector(contanctButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * buyButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xffffff) title:@"立即下单"];
    buyButton.backgroundColor = UIColorFromRGB(0xfa4b30);
    [self.view addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    [buyButton addTarget:self action:@selector(buyButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view bringSubviewToFront:self.backButton];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 510 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:self.seriviceModel.img];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.placeholderImage = [UIImage imageNamed:@"defaultTopBanner"];
    self.bannerView.delegate = self;
    self.bannerView.autoScrollTimeInterval = 3.f;
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(225 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.seriviceModel.amount];
    [headerView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.collectButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(10) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [headerView addSubview:self.collectButton];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceLabel);
        make.right.mas_equalTo(-25 * scale);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self reloadCollectStatus];
    [self.collectButton addTarget:self action:@selector(collectButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.titleLabel.text = self.seriviceModel.title;
    [headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.detailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = self.seriviceModel.remark;
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
    self.logoImageView.clipsToBounds = YES;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.seriviceModel.provider_avatar]];
    if (isEmptyString(self.seriviceModel.provider_avatar)) {
        [self.logoImageView setImage:[UIImage imageNamed:@"defalutLogo"]];
    }
    [headerView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(70 * scale);
        make.width.mas_equalTo(120 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = self.seriviceModel.provider_name;
    [headerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView).offset(5 * scale);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 160 * scale);
    }];
    
    self.favorableLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.favorableLabel.text = self.seriviceModel.provider_tip;
    [headerView addSubview:self.favorableLabel];
    [self.favorableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.logoImageView).offset(-5 * scale);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(10 * scale);
    }];
    
//    self.dealLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
//    [headerView addSubview:self.dealLabel];
//    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.logoImageView).offset(-5 * scale);
//        make.height.mas_equalTo(20 * scale);
//        make.left.mas_equalTo(self.favorableLabel.mas_right).offset(15 * scale);
//    }];
    
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
    return self.seriviceModel.case_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRExampleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRExampleTableViewCell" forIndexPath:indexPath];
    
    FRExampleModel * model = [self.seriviceModel.case_list objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * kMainBoundsWidth / 375.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRExampleModel * model = [self.seriviceModel.case_list objectAtIndex:indexPath.row];
    FRExampleViewController * example = [[FRExampleViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:example animated:YES];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString * url = [self.seriviceModel.img objectAtIndex:index];
    LookImageViewController * look = [[LookImageViewController alloc] initWithImageURL:url];
    [self presentViewController:look animated:YES completion:nil];
}

- (void)backButtonDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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

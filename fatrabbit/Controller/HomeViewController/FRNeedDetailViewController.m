//
//  FRNeedDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRNeedDetailViewController.h"
#import "FRServiceTableViewCell.h"
#import <SDCycleScrollView.h>
#import "FRNeedDetailRequest.h"
#import "MBProgressHUD+FRHUD.h"

@interface FRNeedDetailViewController ()

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) UITableView * tableView;

//头视图展示信息
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;

@property (nonatomic, strong) FRNeedModel * model;

@end

@implementation FRNeedDetailViewController

- (instancetype)initWithNeedModel:(FRNeedModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestNeedDetail];
}

- (void)requestNeedDetail
{
    FRNeedDetailRequest * request = [[FRNeedDetailRequest alloc] initWithNeedID:self.model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            [self.model mj_setKeyValues:data];
        }
        
        [self createViews];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD showTextHUDWithText:@"获取详情失败"];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取详情失败"];
        
    }];
}

- (void)contanctButtonDidClicked
{
    
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kStatusBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    UIButton * contanctButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xffffff) title:@"联系Ta"];
    contanctButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [self.view addSubview:contanctButton];
    [contanctButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    [contanctButton addTarget:self action:@selector(contanctButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self createTableHeaderView];
    
    UIButton * backButton = [FRCreateViewTool createButtonWithFrame:CGRectMake(10, 20, 30, 30) font:kPingFangRegular(10) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [backButton setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 300 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:self.model.img];
    self.bannerView.autoScrollTimeInterval = 3.f;
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2lf", self.model.amount];
    [headerView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.titleLabel.text = self.model.title;
    [headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    NSString * remark = self.model.remark;
    CGFloat height = [remark boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(10 * scale)} context:nil].size.height;
    headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 300 * scale + height);
    self.detailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = remark;
    [headerView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_lessThanOrEqualTo(height + 20 * scale);
    }];
    
    self.tableView.tableHeaderView = headerView;
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

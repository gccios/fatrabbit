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
#import "FRCollectRequest.h"
#import "FRLoginViewController.h"
#import "UserManager.h"

@interface FRNeedDetailViewController ()

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) UITableView * tableView;

//头视图展示信息
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;

@property (nonatomic, strong) FRNeedModel * model;

@property (nonatomic, strong) UIButton * backButton;

@property (nonatomic, strong) UIButton * collectButton;

@property (nonatomic, strong) UIButton * handleButton;

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
    
    self.backButton = [FRCreateViewTool createButtonWithFrame:CGRectMake(10, 20, 30, 30) font:kPingFangRegular(10) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [self.backButton setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(backButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
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
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        
    }];
}

- (void)contanctButtonDidClicked
{
    NSMutableString  *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.mobile];
    
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
    if (self.model.collect_id == 0) {
        FRCollectRequest * request = [[FRCollectRequest alloc] initWithAddNeedID:self.model.cid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            if (KIsDictionary(response)) {
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    self.model.collect_id = [[data objectForKey:@"collect_id"] integerValue];
                }
            }
            [self reloadCollectStatus];
            [MBProgressHUD showTextHUDWithText:@"收藏成功"];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [MBProgressHUD showTextHUDWithText:@"操作失败"];
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
    }else{
        FRCollectRequest * request = [[FRCollectRequest alloc] initWithRemoveID:self.model.collect_id];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            self.model.collect_id = 0;
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
    if (self.model.collect_id != 0) {
        [self.collectButton setImage:[UIImage imageNamed:@"xinxinyes"] forState:UIControlStateNormal];
    }else{
        [self.collectButton setImage:[UIImage imageNamed:@"xinxinno"] forState:UIControlStateNormal];
    }
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
    
    self.handleButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xffffff) title:@"联系Ta"];
    self.handleButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [self.view addSubview:self.handleButton];
    [self.handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    if (self.model.contact_status == 0) {
        [self.handleButton setTitle:@"平台保护客户隐私，请申请联系他们" forState:UIControlStateNormal];
        self.handleButton.backgroundColor = UIColorFromRGB(0xf8bf44);
        [self.handleButton addTarget:self action:@selector(applyButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        self.handleButton.enabled = YES;
    }else if (self.model.contact_status == 1) {
        [self.handleButton setTitle:@"正在审核，审核后会及时通知" forState:UIControlStateNormal];
        self.handleButton.backgroundColor = UIColorFromRGB(0xcccccc);
        self.handleButton.enabled = NO;
    }
    
    if (self.model.contact_status == 2) {
        [self.handleButton setTitle:@"联系Ta" forState:UIControlStateNormal];
        self.handleButton.backgroundColor = UIColorFromRGB(0xf8bf44);
        [self.handleButton addTarget:self action:@selector(contanctButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        self.handleButton.enabled = YES;
    }
    
    [self createTableHeaderView];
    
    [self.view bringSubviewToFront:self.backButton];
}

- (void)applyButtonDidClicked
{
    if (![UserManager shareManager].isLogin) {
        
        [MBProgressHUD showTextHUDWithText:@"请登录后进行操作"];
        
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确认申请" message:@"平台与需求方会对服务商进行资质审核，是否申请？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在发送申请" inView:self.view];
        FRNeedDetailRequest * request = [[FRNeedDetailRequest alloc] initContactWithNeedID:self.model.cid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            
            self.model.contact_status = 1;
            [self.handleButton setTitle:@"正在审核，审核后会及时通知" forState:UIControlStateNormal];
            self.handleButton.backgroundColor = UIColorFromRGB(0xcccccc);
            [self.handleButton addTarget:self action:@selector(applyButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
            self.handleButton.enabled = NO;
            
            
        }  businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"申请失败"];
            
        }];
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 300 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:self.model.img];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.autoScrollTimeInterval = 3.f;
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    if (self.model.amount == 0) {
        self.priceLabel.text = @"面议";
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.model.amount];
    }
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
    
    CGFloat titleHeight = [self.model.title boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangMedium(15 * scale)} context:nil].size.height;
    self.titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.model.title;
    [headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(titleHeight + 10 * scale);
    }];
    
    NSString * remark = self.model.remark;
    CGFloat height = [remark boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(10 * scale)} context:nil].size.height;
    headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 300 * scale + titleHeight + height);
    self.detailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = remark;
    [headerView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_lessThanOrEqualTo(height + 20 * scale);
    }];
    
    UILabel * cateLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    cateLabel.text = [NSString stringWithFormat:@"%@-%@", self.model.first_cate_name, self.model.second_cate_name];
    [headerView addSubview:cateLabel];
    [cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(-10 * scale);
        make.height.mas_equalTo(15 * scale);
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

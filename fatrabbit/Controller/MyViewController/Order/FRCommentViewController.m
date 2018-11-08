//
//  FRCommentViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCommentViewController.h"
#import "FRCommentLevelView.h"
#import "RDTextView.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRCommentRequest.h"

@interface FRCommentViewController () <LMJGradeStarsControlDelegate>

@property (nonatomic, strong) UIView * commentView;

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) UIButton * haopingBtn;
@property (nonatomic, strong) UIButton * zhongpingBtn;
@property (nonatomic, strong) UIButton * chapingBtn;
@property (nonatomic, strong) UIButton * chooseButton;

@property (nonatomic, assign) NSInteger serviceStar;
@property (nonatomic, assign) NSInteger companyStar;
@property (nonatomic, assign) NSInteger businessStar;

@property (nonatomic, strong) RDTextView * textView;

@property (nonatomic, strong) FRCommentLevelView * commentLevelView;

@property (nonatomic, strong) FRMyStoreOrderModel * storeModel;
@property (nonatomic, strong) FRMyServiceOrderModel * serviceModel;

@end

@implementation FRCommentViewController

- (instancetype)initWithStoreModel:(FRMyStoreOrderModel *)model
{
    if (self = [super init]) {
        self.storeModel = model;
    }
    return self;
}

- (instancetype)initWithSeriviceModel:(FRMyServiceOrderModel *)model
{
    if (self = [super init]) {
        self.serviceModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)baseCommentButtonDidClicked:(UIButton *)button
{
    self.chooseButton = button;
    if (button == self.haopingBtn) {
        [self.haopingBtn setTitleColor:KThemeColor forState:UIControlStateNormal];
        [self.zhongpingBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.chapingBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        self.level = 3;
    }else if (button == self.zhongpingBtn) {
        [self.haopingBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.zhongpingBtn setTitleColor:UIColorFromRGB(0x3bc2aa)forState:UIControlStateNormal];
        [self.chapingBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        self.level = 2;
    }else if (button == self.chapingBtn) {
        [self.haopingBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.zhongpingBtn setTitleColor:UIColorFromRGB(0xffffff)forState:UIControlStateNormal];
        [self.chapingBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        self.level = 1;
    }
}

/**
 发布评价
 */
- (void)publishComment
{
    if (self.level == 0) {
        [MBProgressHUD showTextHUDWithText:@"请对整体作出评价"];
        return;
    }
    if (self.serviceStar == 0) {
        [MBProgressHUD showTextHUDWithText:@"请对服务作出评价"];
        return;
    }
    if (self.companyStar == 0) {
        [MBProgressHUD showTextHUDWithText:@"请对公司作出评价"];
        return;
    }
    if (self.businessStar == 0) {
        [MBProgressHUD showTextHUDWithText:@"请对业务作出评价"];
        return;
    }
    NSString * content = self.textView.text;
    if (isEmptyString(content)) {
        [MBProgressHUD showTextHUDWithText:@"请填写文字评价"];
        return;
    }
    if (content.length < 16) {
        [MBProgressHUD showTextHUDWithText:@"文字评价至少需要16个字"];
        return;
    }
    
    if (self.storeModel) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在评价" inView:self.view];
        FRCommentRequest * request = [[FRCommentRequest alloc] initWithStoreID:self.storeModel.cid level:self.level service_star:self.serviceStar company_star:self.companyStar business_star:self.businessStar content:content];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"评价成功"];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(conmentDidCompelete)]) {
                [self.delegate conmentDidCompelete];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
            
        }];
    }else if (self.serviceModel) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在评价" inView:self.view];
        FRCommentRequest * request = [[FRCommentRequest alloc] initServiceComentWithStoreID:self.serviceModel.cid level:self.level service_star:self.serviceStar company_star:self.companyStar business_star:self.businessStar content:content];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"评价成功"];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(conmentDidCompelete)]) {
                [self.delegate conmentDidCompelete];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
            
        }];
    }
}


/**
 LMJGradeStarsControlDelegate
 */
- (void)gradeStarsControl:(LMJGradeStarsControl *)gradeStarsControl selectedStars:(NSInteger)stars
{
    if (gradeStarsControl == self.commentLevelView.serviceLevel) {
        self.serviceStar = stars;
    }else if (gradeStarsControl == self.commentLevelView.companyLevel) {
        self.companyStar = stars;
    }else if (gradeStarsControl == self.commentLevelView.businessLevel) {
        self.businessStar = stars;
    }
}

- (void)createViews
{
    self.navigationItem.title = @"发表评价";
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.commentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.commentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(225 * scale);
    }];
    
    UILabel * baseCommentLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    baseCommentLabel.text = @"整体评价：";
    [self.commentView addSubview:baseCommentLabel];
    [baseCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.haopingBtn = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xffffff) title:@" 好评"];
    [self.haopingBtn setImage:[UIImage imageNamed:@"haoping"] forState:UIControlStateNormal];
    [self.view addSubview:self.haopingBtn];
    [self.haopingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100 * scale);
        make.centerY.mas_equalTo(baseCommentLabel);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(60 * scale);
    }];
    
    self.zhongpingBtn = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xffffff) title:@" 中评"];
    [self.zhongpingBtn setImage:[UIImage imageNamed:@"zhongping"] forState:UIControlStateNormal];
    [self.view addSubview:self.zhongpingBtn];
    [self.zhongpingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.haopingBtn.mas_right).offset(25 * scale);
        make.centerY.mas_equalTo(baseCommentLabel);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(60 * scale);
    }];
    
    self.chapingBtn = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xffffff) title:@" 差评"];
    [self.chapingBtn setImage:[UIImage imageNamed:@"chaping"] forState:UIControlStateNormal];
    [self.view addSubview:self.chapingBtn];
    [self.chapingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.zhongpingBtn.mas_right).offset(25 * scale);
        make.centerY.mas_equalTo(baseCommentLabel);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(60 * scale);
    }];
    
    [self.haopingBtn addTarget:self action:@selector(baseCommentButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.zhongpingBtn addTarget:self action:@selector(baseCommentButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.chapingBtn addTarget:self action:@selector(baseCommentButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textView = [[RDTextView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30 * scale, 165 * scale)];
    self.textView.font = kPingFangRegular(12 * scale);
    self.textView.textColor = UIColorFromRGB(0x333333);
    self.textView.placeholder = @"请输入您对本次订单服务的评价，细节处理是否满意？（至少16字）";
    self.textView.placeholderLabel.textColor = UIColorFromRGB(0xdbdbdb);
    self.textView.placeholderLabel.font = kPingFangRegular(9 * scale);
    [FRCreateViewTool cornerView:self.textView radius:5 * scale];
    self.textView.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.textView.layer.borderWidth = .5f;
    self.textView.maxSize = 200;
    [self.commentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baseCommentLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.bottom.mas_equalTo(-25 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.commentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.commentLevelView = [[FRCommentLevelView alloc] initWithCommentNormal];
    [self.commentLevelView configDelegateWith:self];
    [self.view addSubview:self.commentLevelView];
    [self.commentLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(125 * scale);
    }];
    
    UIButton * publishButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"发布"];
    publishButton.backgroundColor = KPriceColor;
    [self.view addSubview:publishButton];
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40 * scale);
    }];
    [publishButton addTarget:self action:@selector(publishComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self baseCommentButtonDidClicked:self.haopingBtn];
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

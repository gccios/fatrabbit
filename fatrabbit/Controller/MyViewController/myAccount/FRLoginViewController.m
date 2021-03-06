//
//  FRLoginViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/6.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRLoginViewController.h"
#import "FRTelLogInRequest.h"
#import "FRUserInfoRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "UserManager.h"

@interface FRLoginViewController ()

@property (nonatomic, strong) UITextField * telField;
@property (nonatomic, strong) UITextField * codeField;
@property (nonatomic, strong) UIButton * sendButton;

@property (nonatomic, strong) UIButton * loginButton;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) UIView * bottomView;

@end

@implementation FRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"登录";
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginWith:) name:DDUserDidGetWeChatCodeNotification object:nil];
}

- (void)userLoginWith:(NSNotification *)notification
{
    SendAuthResp * resp = notification.object;
    if (resp.errCode) {
        [MBProgressHUD showTextHUDWithText:@"授权失败"];
    }else{
        if (isEmptyString(resp.code)) {
            [MBProgressHUD showTextHUDWithText:@"授权失败"];
        }else{
            [self loginUserWithCode:resp.code];
        }
    }
}

- (void)loginUserWithCode:(NSString *)code
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在登录" inView:self.view];
    FRTelLogInRequest * request = [[FRTelLogInRequest alloc] initWithWeChatCode:code];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            [UserManager shareManager].uid = [[data objectForKey:@"uid"] integerValue];
            [UserManager shareManager].token = [data objectForKey:@"token"];
            
            NSString * mobile = [data objectForKey:@"mobile"];
            if (isEmptyString(mobile)) {
                [self bindMobile];
            }else{
                [[UserManager shareManager] loginSuccessWithUid:[UserManager shareManager].uid token:[UserManager shareManager].token mobile:mobile];
                [self requestUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        [hud hideAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [hud hideAnimated:YES];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [hud hideAnimated:YES];
        
    }];
}

- (void)bindMobile
{
    [MBProgressHUD showTextHUDWithText:@"请先绑定您本人的手机号码"];
    self.bottomView.hidden = YES;
    self.navigationItem.title = @"绑定手机号码";
    
    [self.loginButton setTitle:@"确定绑定" forState:UIControlStateNormal];
    [self.loginButton removeTarget:self action:@selector(loginWithTel) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(bindWithTel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sendButton removeTarget:self action:@selector(sendButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton addTarget:self action:@selector(sendBindCode) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendBindCode
{
    NSString * mobile = self.telField.text;
    if (isEmptyString(mobile)) {
        [MBProgressHUD showTextHUDWithText:@"请输入手机号码"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取验证码" inView:self.view];
    FRTelLogInRequest * send = [[FRTelLogInRequest alloc] initWithSendBindCode:mobile];
    [send sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.sendButton.enabled = NO;
        self.time = 60;
        [self timeDidChange];
        [hud hideAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [hud hideAnimated:YES];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [hud hideAnimated:YES];
        
    }];
}

- (void)bindWithTel
{
    NSString * mobile = self.telField.text;
    NSString * code = self.codeField.text;
    if (isEmptyString(mobile)) {
        [MBProgressHUD showTextHUDWithText:@"请输入手机号码"];
        return;
    }
    if (isEmptyString(code)) {
        [MBProgressHUD showTextHUDWithText:@"请输入验证码"];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在登录" inView:self.view];
    FRTelLogInRequest * request = [[FRTelLogInRequest alloc] initWithBindMobile:mobile code:code];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if (KIsDictionary(response)) {
            [[UserManager shareManager] loginSuccessWithUid:[UserManager shareManager].uid token:[UserManager shareManager].token mobile:mobile];
            [self requestUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"登录失败"];
        
    }];
}

- (void)sendButtonDidClicked
{
    NSString * mobile = self.telField.text;
    if (isEmptyString(mobile)) {
        [MBProgressHUD showTextHUDWithText:@"请输入手机号码"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取验证码" inView:self.view];
    FRTelLogInRequest * send = [[FRTelLogInRequest alloc] initWithSendCode:mobile];
    [send sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.sendButton.enabled = NO;
        self.time = 60;
        [self timeDidChange];
        [hud hideAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [hud hideAnimated:YES];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [hud hideAnimated:YES];
        
    }];
}

- (void)timeDidChange
{
    self.time--;
    
    if (self.time == 0) {
        self.sendButton.enabled = YES;
        [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    
    NSString * title = [NSString stringWithFormat:@"%lds", self.time];
    [self.sendButton setTitle:title forState:UIControlStateNormal];
    
    [self performSelector:@selector(timeDidChange) withObject:nil afterDelay:1.f];
}

- (void)loginWithTel
{
    NSString * mobile = self.telField.text;
    NSString * code = self.codeField.text;
    if (isEmptyString(mobile)) {
        [MBProgressHUD showTextHUDWithText:@"请输入手机号码"];
        return;
    }
    if (isEmptyString(code)) {
        [MBProgressHUD showTextHUDWithText:@"请输入验证码"];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在登录" inView:self.view];
    FRTelLogInRequest * request = [[FRTelLogInRequest alloc] initWithTel:mobile code:code];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                
                NSInteger uid = [[data objectForKey:@"uid"] integerValue];
                NSString * token = [data objectForKey:@"token"];
                NSString * mobile = @"18811129211";
                
                [[UserManager shareManager] loginSuccessWithUid:uid token:token mobile:mobile];
                [self requestUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"登录失败"];
        
    }];
    
}

- (void)loginWithQQ
{
    
}

- (void)loginWithWeChat
{
    [[UserManager shareManager] loginWithWeChat];
}

- (void)requestUserInfo
{
    FRUserInfoRequest * info = [[FRUserInfoRequest alloc] initWithUserID:[UserManager shareManager].uid];
    
    [info sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                [[UserManager shareManager] mj_setKeyValues:data];
                [[UserManager shareManager] needUpdateLocalUserInfo];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * telView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:telView];
    [telView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    
    UIImageView * telImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"telPhone"]];
    [telView addSubview:telImageView];
    [telImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10 * scale);
        make.left.mas_equalTo(30 * scale);
        make.width.height.mas_equalTo(20 * scale);
    }];
    
    self.telField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.telField.placeholder = @"请输入手机号";
    self.telField.textColor = UIColorFromRGB(0x333333);
    self.telField.font = kPingFangRegular(13 * scale);
    [telView addSubview:self.telField];
    [self.telField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(telImageView);
        make.left.mas_equalTo(telImageView.mas_right).offset(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 140 * scale);
    }];
    
    UIView * telLineView = [[UIView alloc] initWithFrame:CGRectZero];
    telLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [telView addSubview:telLineView];
    [telLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(telImageView.mas_right).offset(10 * scale);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth - 15 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    UIView * codeView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(telView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    
    UIImageView * codeImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"code"]];
    [codeView addSubview:codeImageView];
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10 * scale);
        make.left.mas_equalTo(30 * scale);
        make.width.height.mas_equalTo(20 * scale);
    }];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.codeField.placeholder = @"请输入验证码";
    self.codeField.textColor = UIColorFromRGB(0x333333);
    self.codeField.font = kPingFangRegular(13 * scale);
    [codeView addSubview:self.codeField];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(codeImageView);
        make.left.mas_equalTo(codeImageView.mas_right).offset(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-125 * scale);
    }];
    
    self.sendButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(13 * scale) titleColor:UIColorFromRGB(0x999999) title:@"获取验证码"];
    [codeView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5 * scale);
        make.left.mas_equalTo(self.codeField.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(100 * scale);
    }];
    [FRCreateViewTool cornerView:self.sendButton radius:4.f * scale];
    self.sendButton.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    self.sendButton.layer.borderWidth = .5f;
    [self.sendButton addTarget:self action:@selector(sendButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * codeLineView = [[UIView alloc] initWithFrame:CGRectZero];
    codeLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [codeView addSubview:codeLineView];
    [codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeImageView.mas_right).offset(10 * scale);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-125 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    self.loginButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(16 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"登录"];
    self.loginButton.backgroundColor = KThemeColor;
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeView.mas_bottom).offset(50 * scale);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(230 * scale);
        make.height.mas_equalTo(30 * scale);
    }];
    [FRCreateViewTool cornerView:self.loginButton radius:15 * scale];
    [self.loginButton addTarget:self action:@selector(loginWithTel) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(kMainBoundsHeight / 2.f);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [self.bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40 * scale);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(1);
    }];
    
    UILabel * loginTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentCenter];
    loginTipLabel.backgroundColor = self.view.backgroundColor;
    loginTipLabel.text = @"一键快捷登录";
    [self.bottomView addSubview:loginTipLabel];
    [loginTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(lineView);
        make.width.mas_equalTo(120 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
//    UIButton * QQButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12) titleColor:UIColorFromRGB(0xffffff) title:@""];
//    [QQButton setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
//    [self.bottomView addSubview:QQButton];
//    [QQButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(lineView.mas_bottom).offset(50 * scale);
//        make.centerX.mas_equalTo(-50);
//        make.width.height.mas_equalTo(42 * scale);
//    }];
//    [QQButton addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * wxButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [wxButton setImage:[UIImage imageNamed:@"weChat"] forState:UIControlStateNormal];
    [self.bottomView addSubview:wxButton];
    [wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(50 * scale);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(42 * scale);
    }];
    [wxButton addTarget:self action:@selector(loginWithWeChat) forControlEvents:UIControlEventTouchUpInside];
    if (![WXApi isWXAppInstalled]) {
        wxButton.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDUserDidGetWeChatCodeNotification object:nil];
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

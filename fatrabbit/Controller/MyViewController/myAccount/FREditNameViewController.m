//
//  FREditNameViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FREditNameViewController.h"
#import "UserManager.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRUserInfoUpdateRequest.h"

@interface FREditNameViewController ()

@property (nonatomic, strong) UITextField * nameField;

@end

@implementation FREditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)saveButtonDidClicked
{
    NSString * nickName = self.nameField.text;
    if (isEmptyString(nickName)) {
        [MBProgressHUD showTextHUDWithText:@"请输入昵称"];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在保存" inView:self.view];
    FRUserInfoUpdateRequest * request = [[FRUserInfoUpdateRequest alloc] initWithNickName:nickName avatar:nil];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"保存成功"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(FRUserNickNameDidUpdate:)]) {
            [self.delegate FRUserNickNameDidUpdate:nickName];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"保存失败"];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接错误"];
        
    }];
}

- (void)createViews
{
    self.navigationItem.title = @"修改昵称";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(52 * scale);
    }];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameField.placeholder = @"请输入昵称";
    self.nameField.textColor = UIColorFromRGB(0x999999);
    self.nameField.font = kPingFangRegular(13 * scale);
    [nameView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-25 * scale);
    }];
    self.nameField.text = [UserManager shareManager].nickname;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [nameView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    UIButton * saveButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"保存"];
    saveButton.frame = CGRectMake(0, 0, 40 * scale, 30 * scale);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [saveButton addTarget:self action:@selector(saveButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
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

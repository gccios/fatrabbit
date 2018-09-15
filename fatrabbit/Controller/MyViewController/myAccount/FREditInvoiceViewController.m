//
//  FREditInvoiceViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FREditInvoiceViewController.h"

@interface FREditInvoiceViewController ()

@property (nonatomic, strong) UITextField * companyField;
@property (nonatomic, strong) UITextField * numberField;
@property (nonatomic, strong) UITextField * addressField;
@property (nonatomic, strong) UITextField * mobileField;
@property (nonatomic, strong) UITextField * bankField;
@property (nonatomic, strong) UITextField * bankAccountField;

@end

@implementation FREditInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)saveButtonDidClicked
{
    
}

- (void)createViews
{
    self.navigationItem.title = @"发票信息";
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel * companyLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    companyLabel.text = @"单位名称";
    [self.view addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(80 * scale);
    }];
    
    self.companyField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.companyField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.companyField];
    [self.companyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(companyLabel);
        make.left.mas_equalTo(companyLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    UILabel * numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    numberLabel.text = @"纳税识别码";
    [self.view addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(companyLabel.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(80 * scale);
    }];
    
    self.numberField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.numberField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.numberField];
    [self.numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(numberLabel);
        make.left.mas_equalTo(numberLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    UILabel * addressLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    addressLabel.text = @"注册地址";
    [self.view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(numberLabel.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(80 * scale);
    }];
    
    self.addressField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.addressField];
    [self.addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(addressLabel);
        make.left.mas_equalTo(addressLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    UILabel * mobileLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    mobileLabel.text = @"注册电话";
    [self.view addSubview:mobileLabel];
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLabel.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(80 * scale);
    }];
    
    self.mobileField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.mobileField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.mobileField];
    [self.mobileField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(mobileLabel);
        make.left.mas_equalTo(mobileLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    UILabel * bankLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    bankLabel.text = @"开户银行";
    [self.view addSubview:bankLabel];
    [bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mobileLabel.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(80 * scale);
    }];
    
    self.bankField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.bankField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.bankField];
    [self.bankField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bankLabel);
        make.left.mas_equalTo(bankLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    UILabel * bankAccountLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    bankAccountLabel.text = @"银行账户";
    [self.view addSubview:bankAccountLabel];
    [bankAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bankLabel.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(80 * scale);
    }];
    
    self.bankAccountField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.bankAccountField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.bankAccountField];
    [self.bankAccountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bankAccountLabel);
        make.left.mas_equalTo(bankAccountLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
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

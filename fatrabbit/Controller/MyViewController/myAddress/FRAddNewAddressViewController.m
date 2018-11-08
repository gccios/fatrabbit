//
//  FRAddNewAddressViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAddNewAddressViewController.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRUserAddressRequest.h"

@interface FRAddNewAddressViewController ()

@property (nonatomic, strong) FRAddressModel * model;

@property (nonatomic, strong) UITextField * nameField;
@property (nonatomic, strong) UITextField * telField;
@property (nonatomic, strong) UITextField * addressField;

@property (nonatomic, strong) UIButton * addButton;

@end

@implementation FRAddNewAddressViewController

- (instancetype)initWithEditModel:(FRAddressModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"新增收货地址";
    
    [self createViews];
}

- (void)addButtonDidClicked
{
    NSString * name = self.nameField.text;
    NSString * mobile = self.telField.text;
    NSString * address = self.addressField.text;
    if (isEmptyString(name)) {
        [MBProgressHUD showTextHUDWithText:@"请输入收货人信息"];
        return;
    }
    if (isEmptyString(mobile)) {
        [MBProgressHUD showTextHUDWithText:@"请输入手机号码"];
    }
    if (isEmptyString(address)) {
        [MBProgressHUD showTextHUDWithText:@"请输入收货地址"];
    }
    
    FRUserAddressRequest * request = [[FRUserAddressRequest alloc] initAddWith:name tel:mobile address:address];
    
    if (self.model) {
        request = [[FRUserAddressRequest alloc] initEditWith:name tel:mobile address:address addressID:self.model.cid];
    }
    
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD showTextHUDWithText:@"地址保存成功"];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(FRAddressDidChange)]) {
            [self.delegate FRAddressDidChange];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络连接失败"];
        
    }];
}

- (void)deleteButtonDidClicked
{
    FRUserAddressRequest * request = [[FRUserAddressRequest alloc] initDeleteWith:self.model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD showTextHUDWithText:@"地址删除成功"];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(FRAddressDidChange)]) {
            [self.delegate FRAddressDidChange];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD showTextHUDWithText:@"删除失败"];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络连接失败"];
        
    }];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    
    UILabel * nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    nameLabel.text = @"收货人";
    [nameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0 * scale);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(60 * scale);
    }];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameField.textColor = UIColorFromRGB(0x999999);
    self.nameField.font = kPingFangRegular(13 * scale);
    [nameView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(nameLabel.mas_right).offset(20 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-25 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [nameView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    UIView * telView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:telView];
    [telView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    
    UILabel * telLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    telLabel.text = @"手机号码";
    [telView addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0 * scale);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(60 * scale);
    }];
    
    self.telField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.telField.textColor = UIColorFromRGB(0x999999);
    self.telField.font = kPingFangRegular(13 * scale);
    self.telField.keyboardType = UIKeyboardTypeNumberPad;
    [telView addSubview:self.telField];
    [self.telField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(telLabel.mas_right).offset(20 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-25 * scale);
    }];
    
    UIView * telLineView = [[UIView alloc] initWithFrame:CGRectZero];
    telLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [telView addSubview:telLineView];
    [telLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    UIView * addressView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(telView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    
    UILabel * addressLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    addressLabel.text = @"收货地址";
    [addressView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0 * scale);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(60 * scale);
    }];
    
    self.addressField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.addressField.textColor = UIColorFromRGB(0x999999);
    self.addressField.font = kPingFangRegular(13 * scale);
    [addressView addSubview:self.addressField];
    [self.addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(addressLabel.mas_right).offset(20 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-25 * scale);
    }];
    
    UIView * addressLineView = [[UIView alloc] initWithFrame:CGRectZero];
    addressLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [addressView addSubview:addressLineView];
    [addressLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    self.addButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"保存"];
    self.addButton.backgroundColor = KThemeColor;
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(40 * scale);
    }];
    [self.addButton addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.model) {
        self.nameField.text = self.model.consignee;
        self.telField.text = self.model.mobile;
        self.addressField.text = self.model.address;
        
        UIButton * deleteButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"删除"];
        deleteButton.frame = CGRectMake(0, 0, 40 * scale, 30 * scale);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
        [deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
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

//
//  FRSearchViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRSearchViewController.h"
#import "FRServiceTableViewCell.h"
#import "FRNavAutoView.h"
#import <IQKeyboardManager.h>

@interface FRSearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField * searchTextField;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    FRNavAutoView * navView = [[FRNavAutoView alloc] initWithFrame:CGRectMake(70 * scale, 0, kMainBoundsWidth - 90 * scale, kNaviBarHeight)];
    self.navigationItem.titleView = navView;
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    self.searchTextField.font = kPingFangRegular(14 * scale);
    self.searchTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.4f];
    [navView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(30 * scale);
    }];
    
    self.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * scale, 30 * scale)];
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [FRCreateViewTool cornerView:self.searchTextField radius:15 * scale];
    
    self.searchTextField.placeholder = @"搜索企业/服务/案例/分类等，专业团队";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xEFEFF4);
    self.tableView.rowHeight = 60;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRServiceTableViewCell class] forCellReuseIdentifier:@"FRServiceTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(10 * scale, 0, 10 * scale, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.searchTextField canBecomeFirstResponder]) {
            [self.searchTextField becomeFirstResponder];
        }
    });
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [self keyBoardDidEndEditing];
    }
    
    return YES;
}

- (void)keyBoardDidEndEditing
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
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

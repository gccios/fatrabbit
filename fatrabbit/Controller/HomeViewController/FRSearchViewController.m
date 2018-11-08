//
//  FRSearchViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRSearchViewController.h"
#import "FRTableTabView.h"
#import "FRNeedTableViewCell.h"
#import "FRServiceTableViewCell.h"
#import "FRNavAutoView.h"
#import <IQKeyboardManager.h>
#import "FRSearchRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import <MJRefresh.h>
#import "FRServiceDetailViewController.h"
#import "FRNeedDetailViewController.h"

@interface FRSearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField * searchTextField;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * needSource;
@property (nonatomic, strong) NSMutableArray * seriviceSource;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger tabType;

@property (nonatomic, strong) FRTableTabView * tableTabView;

@property (nonatomic, strong) UIView * noDataView;

@end

@implementation FRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabType = 1;
    [self createViews];
}

- (void)requestSource
{
    FRSearchRequest * request = [[FRSearchRequest alloc] initIndexSearchWithPage:1 keyword:self.searchTextField.text];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                NSArray * needList = [data objectForKey:@"demand_list"];
                [self.needSource removeAllObjects];
                [self.needSource addObjectsFromArray:[FRNeedModel mj_objectArrayWithKeyValuesArray:needList]];
                
                NSArray * serviceList = [data objectForKey:@"service_list"];
                [self.seriviceSource removeAllObjects];
                [self.seriviceSource addObjectsFromArray:[FRMySeriviceModel mj_objectArrayWithKeyValuesArray:serviceList]];
            }
            [self.tableView reloadData];
            self.page = 2;
        }
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreSource
{
    FRSearchRequest * request = [[FRSearchRequest alloc] initIndexSearchWithPage:self.page keyword:self.searchTextField.text];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                NSArray * needList = [data objectForKey:@"demand_list"];
                [self.needSource addObjectsFromArray:[FRNeedModel mj_objectArrayWithKeyValuesArray:needList]];
                
                NSArray * serviceList = [data objectForKey:@"service_list"];
                [self.seriviceSource addObjectsFromArray:[FRMySeriviceModel mj_objectArrayWithKeyValuesArray:serviceList]];
            }
            [self.tableView reloadData];
            self.page++;
        }
        [self.tableView.mj_footer endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [self.tableView.mj_footer endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [self.tableView.mj_footer endRefreshing];
        
    }];
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
    
    self.searchTextField.placeholder = @" 搜索企业/服务/案例/分类等，专业团队";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRServiceTableViewCell class] forCellReuseIdentifier:@"FRServiceTableViewCell"];
    [self.tableView registerClass:[FRNeedTableViewCell class] forCellReuseIdentifier:@"FRNeedTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(50 * scale);
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSource)];
    
    self.tableTabView = [[FRTableTabView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 50 * scale)];
    [self.view addSubview:self.tableTabView];
    [self.tableTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    __weak typeof(self) weakSelf = self;
    self.tableTabView.leftButtonClickedHandle = ^{
        [weakSelf changeToNeed];
    };
    self.tableTabView.rightButtonClickedHandle = ^{
        [weakSelf changeToSerivice];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.searchTextField canBecomeFirstResponder]) {
            [self.searchTextField becomeFirstResponder];
        }
    });
    
    self.noDataView = [[UIView alloc] initWithFrame:CGRectZero];
    self.noDataView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50 * scale);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    UILabel * noDataLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentCenter];
    noDataLabel.text = @"未找到您想要的东西";
    [self.noDataView addSubview:noDataLabel];
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(30 * scale);
    }];
    self.noDataView.hidden = YES;
}

- (void)changeToNeed
{
    if (self.tabType == 1) {
        return;
    }
    self.tabType = 1;
    [self.tableView reloadData];
}

- (void)changeToSerivice
{
    if (self.tabType == 2) {
        return;
    }
    self.tabType = 2;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tabType == 1) {
        if (self.needSource.count == 0) {
            [self showNoDataView];
        }else{
            [self hiddenNoDataView];
        }
        return self.needSource.count;
    }else{
        if (self.seriviceSource.count == 0) {
            [self showNoDataView];
        }else{
            [self hiddenNoDataView];
        }
        return self.seriviceSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tabType == 1) {
        FRNeedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRNeedTableViewCell" forIndexPath:indexPath];
        
        FRNeedModel * model = [self.needSource objectAtIndex:indexPath.row];
        [cell configWithModel:model];
        
        return cell;
    }else{
        FRServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRServiceTableViewCell" forIndexPath:indexPath];
        
        FRMySeriviceModel * model = [self.seriviceSource objectAtIndex:indexPath.row];
        [cell configWithModel:model];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * kMainBoundsWidth / 375.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tabType == 1) {
        FRNeedModel * model = [self.needSource objectAtIndex:indexPath.row];
        
        FRNeedDetailViewController * need = [[FRNeedDetailViewController alloc] initWithNeedModel:model];
        [self.navigationController pushViewController:need animated:YES];
        
    }else{
        FRMySeriviceModel * model = [self.seriviceSource objectAtIndex:indexPath.row];
        
        FRServiceDetailViewController * service = [[FRServiceDetailViewController alloc] initWithSeriviceModel:model];
        [self.navigationController pushViewController:service animated:YES];
    }
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
    [self requestSource];
}

- (void)showNoDataView
{
    self.noDataView.hidden = NO;
}

- (void)hiddenNoDataView
{
    self.noDataView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (NSMutableArray *)needSource
{
    if (!_needSource) {
        _needSource = [[NSMutableArray alloc] init];
    }
    return _needSource;
}

- (NSMutableArray *)seriviceSource
{
    if (!_seriviceSource) {
        _seriviceSource = [[NSMutableArray alloc] init];
    }
    return _seriviceSource;
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

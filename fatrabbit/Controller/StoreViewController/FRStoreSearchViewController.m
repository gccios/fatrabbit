//
//  FRStoreSearchViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreSearchViewController.h"
#import "FRNavAutoView.h"
#import <IQKeyboardManager.h>
#import "FRStoreListViewController.h"
#import "FRStoreSearchRequest.h"
#import "UIButton+RSButton.h"
#import "FRStoreTableViewCell.h"
#import "FRChooseSpecView.h"
#import "FRStoreDetailRequest.h"
#import "FRStoreDetailViewController.h"
#import "MBProgressHUD+FRHUD.h"
#import "UserManager.h"
#import <MJRefresh.h>

@interface FRStoreSearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * cateTableView;
@property (nonatomic, strong) NSMutableArray * cateList;
@property (nonatomic, strong) FRCateModel * chooseCateModel;
@property (nonatomic, strong) FRStoreBlockModel * blockModel;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIButton * cateButton;
@property (nonatomic, strong) UIButton * dealButton;
@property (nonatomic, strong) UIButton * priceButton;
@property (nonatomic, assign) FRStoreSearchType searchType;
@property (nonatomic, assign) BOOL isPriceDown;

@property (nonatomic, strong) UITextField * searchTextField;

@end

@implementation FRStoreSearchViewController

- (instancetype)initWithStoreBlockModel:(FRStoreBlockModel *)model cateList:(NSArray *)cateList
{
    if (self = [super init]) {
        self.cateList = [[NSMutableArray alloc] initWithArray:cateList];
        
        FRCateModel * allModel = [[FRCateModel alloc] init];
        allModel.cid = 0;
        allModel.name = model.label_title;
        self.chooseCateModel = allModel;
        
        if (model) {
            self.blockModel = model;
        }
        
        [self.cateList insertObject:allModel atIndex:0];
    }
    return self;
}

- (instancetype)initWithCateModel:(FRCateModel *)model cateList:(NSArray *)cateList
{
    if (self = [super init]) {
        self.cateList = [[NSMutableArray alloc] initWithArray:cateList];
        
        FRCateModel * allModel = [[FRCateModel alloc] init];
        allModel.cid = 0;
        allModel.name = @"全部商品";
        
        if (model) {
            self.chooseCateModel = model;
        }else{
            self.chooseCateModel = allModel;
        }
        
        [self.cateList insertObject:allModel atIndex:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)tabButtonDidClicked:(UIButton *)button
{
    if (button == self.cateButton) {
        [self cateButtonClicked];
    }else if (button == self.dealButton) {
        [self dealButtonClicked];
    }else if (button == self.priceButton) {
        [self priceButtonClicked];
    }
}

- (void)cateButtonClicked
{
    if (self.searchType == FRStoreSearchType_Cate) {
        self.cateTableView.hidden = !self.cateTableView.hidden;
        return;
    }
    self.searchType = FRStoreSearchType_Cate;
    [self reloadPage];
}

- (void)dealButtonClicked
{
    if (self.searchType == FRStoreSearchType_Deal) {
        return;
    }
    self.cateTableView.hidden = YES;
    self.searchType = FRStoreSearchType_Deal;
    [self reloadPage];
}

- (void)priceButtonClicked
{
    if (self.searchType == FRStoreSearchType_Price) {
        
        self.isPriceDown = !self.isPriceDown;
    }
    self.cateTableView.hidden = YES;
    self.searchType = FRStoreSearchType_Price;
    [self reloadPage];
}

- (void)reloadPage
{
    if (self.searchType == FRStoreSearchType_Cate) {
        [self.cateButton setTitleColor:KThemeColor forState:UIControlStateNormal];
        [self.dealButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.priceButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.cateButton setTitle:self.chooseCateModel.name forState:UIControlStateNormal];
    }else if (self.searchType == FRStoreSearchType_Deal) {
        [self.cateButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.dealButton setTitleColor:KThemeColor forState:UIControlStateNormal];
        [self.priceButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }else if (self.searchType == FRStoreSearchType_Price) {
        [self.cateButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.dealButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.priceButton setTitleColor:KThemeColor forState:UIControlStateNormal];
        if (self.isPriceDown) {
            [self.priceButton setImage:[UIImage imageNamed:@"priceUp"] forState:UIControlStateNormal];
        }else{
            [self.priceButton setImage:[UIImage imageNamed:@"priceDown"] forState:UIControlStateNormal];
        }
    }
    [self searchRequest];
}

- (void)searchRequest
{
    FRStoreSearchRequest * request = [[FRStoreSearchRequest alloc] init];
    NSString * keyWord = self.searchTextField.text;
    if (!isEmptyString(keyWord)) {
        [request configWithKeyWord:keyWord];
    }
    if (self.chooseCateModel) {
        [request configWithCateID:self.chooseCateModel.cid];
    }
    if (self.blockModel) {
        [request configWithBlockID:self.blockModel.label_id];
    }
    
    if (self.searchType == FRStoreSearchType_Deal) {
        [request configDealNumber];
    }else if (self.searchType == FRStoreSearchType_Price) {
        if (self.isPriceDown) {
            [request configPriceUp];
        }else{
            [request configPriceDown];
        }
    }
    
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                [self.dataSource addObjectsFromArray:[FRStoreModel mj_objectArrayWithKeyValuesArray:data]];
            }
        }
        [self.tableView reloadData];
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
    
    self.searchTextField.placeholder = @" 搜索商品名称";
    
    UIView * tabView = [[UIView alloc] initWithFrame:CGRectZero];
    tabView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    
    self.cateButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0x333333) title:@"全部商品"];
    [tabView addSubview:self.cateButton];
    [self.cateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 3.f);
    }];
    [self.cateButton addTarget:self action:@selector(tabButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * cateMoreImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"moreDownColor"]];
    [self.cateButton addSubview:cateMoreImageView];
    [cateMoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15 * scale);
        make.width.height.mas_equalTo(10 * scale);
    }];
    
    self.dealButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0x333333) title:@"销量"];
    [tabView addSubview:self.dealButton];
    [self.dealButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 3.f);
    }];
    [self.dealButton addTarget:self action:@selector(tabButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.priceButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0x333333) title:@"价格"];
    [self.priceButton setImage:[UIImage imageNamed:@"priceDown"] forState:UIControlStateNormal];
    [tabView addSubview:self.priceButton];
    [self.priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 3.f);
    }];
    [self.priceButton addTarget:self action:@selector(tabButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceButton setButtonShowType:RSButtonTypeLeft];
    
    self.searchType = FRStoreSearchType_Cate;
    
    [self reloadPage];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRStoreTableViewCell class] forCellReuseIdentifier:@"FRStoreTableViewCell"];
    self.tableView.rowHeight = 110 * scale;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tabView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10 * scale)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10 * scale)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(searchRequest)];
    
    self.cateTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.cateTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    self.cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cateTableView.rowHeight = 40 * scale;
    self.cateTableView.delegate = self;
    self.cateTableView.dataSource = self;
    [self.cateTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.cateTableView];
    [self.cateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tabView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    self.cateTableView.hidden = YES;
}

- (void)showChooseSpecWith:(FRStoreModel *)model
{
    if (model.spec) {
        if (model.spec.count == 1) {
            [[UserManager shareManager] addStoreCartWithStore:model.spec.firstObject];
            return;
        }
        
        FRChooseSpecView * spec = [[FRChooseSpecView alloc] initWithSpecList:model.spec chooseModel:model.spec.firstObject];
        spec.chooseDidCompletetHandle = ^(FRStoreSpecModel *model) {
            [[UserManager shareManager] addStoreCartWithStore:model];
        };
        [spec show];
    }else{
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取商品详情" inView:self.view];
        FRStoreDetailRequest * request = [[FRStoreDetailRequest alloc] initWithID:model.pid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            if (KIsDictionary(response)) {
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    [model mj_setKeyValues:data];
                    [self showChooseSpecWith:model];
                }
            }
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"获取商品失败"];
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.cateTableView) {
        return self.cateList.count;
    }
    return self.dataSource.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.cateTableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xffffff);
        
        cell.textLabel.font = kPingFangRegular(12);
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        
        FRCateModel * model = [self.cateList objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        
        return cell;
    }
    FRStoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRStoreTableViewCell" forIndexPath:indexPath];
    
    FRStoreModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.storeCartHandle = ^{
        [weakSelf showChooseSpecWith:model];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.cateTableView) {
        FRCateModel * model = [self.cateList objectAtIndex:indexPath.row];
        if (model != self.chooseCateModel) {
            self.chooseCateModel = model;
            [self reloadPage];
        }
        tableView.hidden = YES;
    }else{
        FRStoreModel * model = [self.dataSource objectAtIndex:indexPath.row];
        FRStoreDetailViewController * detail = [[FRStoreDetailViewController alloc] initWithModel:model];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [self keyBoardDidEndEditing];
        
        [self searchRequest];
    }
    
    return YES;
}

- (void)keyBoardDidEndEditing
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}

- (void)navBackButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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

//
//  FRCatePageDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCatePageDetailViewController.h"
#import "FRNeedTableViewCell.h"
#import "FRServiceTableViewCell.h"
#import "FRTableTabView.h"
#import "FRHomeIndexRequest.h"
#import "FRNeedDetailViewController.h"
#import "FRServiceDetailViewController.h"
#import "FRBannerModel.h"
#import <SDCycleScrollView.h>
#import <MJRefresh.h>

@interface FRCatePageDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FRCateModel * model;

@property (nonatomic, strong) NSMutableArray * bannerSource;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * needSource;
@property (nonatomic, strong) NSMutableArray * serviceSource;

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) FRTableTabView * tableTabView;

@property (nonatomic, assign) NSInteger tabType;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger servicePage;

@property (nonatomic, strong) UILabel * nodataLabel;

@end

@implementation FRCatePageDetailViewController

- (instancetype)initWithCateModel:(FRCateModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.servicePage = 1;
    self.tabType = 1;
    [self createViews];
    [self requestNeedSource];
    [self requestAdv];
}

- (void)requestAdv
{
    FRHomeIndexRequest * advRequest = [[FRHomeIndexRequest alloc] initCateAdvWithCateID:self.model.cid];
    [advRequest sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                [self.bannerSource removeAllObjects];
                [self.bannerSource addObjectsFromArray:[FRBannerModel mj_objectArrayWithKeyValuesArray:data]];
            }
            [self createTableHeaderView];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

//获取需求列表
- (void)requestNeedSource
{
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initCateNeedWithCateID:self.model.cid page:1];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * data = [response objectForKey:@"data"];
        if (KIsArray(data)) {
            [self.needSource removeAllObjects];
            [self.needSource addObjectsFromArray:[FRNeedModel mj_objectArrayWithKeyValuesArray:data]];
        }
        [self.tableView reloadData];
        self.page = 2;
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreNeed
{
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initCateNeedWithCateID:self.model.cid page:self.page];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        NSArray * data = [response objectForKey:@"data"];
        if (KIsArray(data)) {
            [self.needSource addObjectsFromArray:[FRNeedModel mj_objectArrayWithKeyValuesArray:data]];
            
            if (data.count > 0) {
                [self.tableView reloadData];
                self.page += 1;
            }
        }
        [self.tableView.mj_footer endRefreshing];

    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        [self.tableView.mj_footer endRefreshing];

    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {

        [self.tableView.mj_footer endRefreshing];

    }];
}

//获取服务列表
- (void)requestServiceSource
{
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initCateServiceWithCateID:self.model.cid page:1];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * data = [response objectForKey:@"data"];
        if (KIsArray(data)) {
            [self.serviceSource removeAllObjects];
            [self.serviceSource addObjectsFromArray:[FRMySeriviceModel mj_objectArrayWithKeyValuesArray:data]];
        }
        [self.tableView reloadData];
        self.servicePage = 2;
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreService
{
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initCateServiceWithCateID:self.model.cid page:self.servicePage];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * data = [response objectForKey:@"data"];
        if (KIsArray(data) && data.count > 0) {
            [self.serviceSource addObjectsFromArray:[FRMySeriviceModel mj_objectArrayWithKeyValuesArray:data]];
            
            [self.tableView reloadData];
            self.servicePage += 1;
        }
        [self.tableView.mj_footer endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_footer endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.nodataLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14) textColor:[UIColor grayColor] alignment:NSTextAlignmentCenter];
    self.nodataLabel.backgroundColor = self.view.backgroundColor;
    self.nodataLabel.text = @"未找到您想要的东西";
    [self.view addSubview:self.nodataLabel];
    [self.nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(300 * scale);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-80 * scale);
    }];
    self.nodataLabel.hidden = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRNeedTableViewCell class] forCellReuseIdentifier:@"FRNeedTableViewCell"];
    [self.tableView registerClass:[FRServiceTableViewCell class] forCellReuseIdentifier:@"FRServiceTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNeedSource)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNeed)];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 200 * scale)];
    
    if (self.bannerSource.count == 0) {
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageNamesGroup:@[@"defaultBanner.jpg"]];
        [headerView addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(150 * scale);
        }];
    }else{
        NSMutableArray * imageSource = [[NSMutableArray alloc] init];
        for (FRBannerModel * model in self.bannerSource) {
            [imageSource addObject:model.img];
        }
        
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:imageSource];
        [headerView addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(150 * scale);
        }];
    }
    
    self.tableTabView = [[FRTableTabView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:self.tableTabView];
    [self.tableTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10 * scale);
        make.height.mas_equalTo(40 * scale);
    }];
    __weak typeof(self) weakSelf = self;
    self.tableTabView.leftButtonClickedHandle = ^{
        [weakSelf changeToNeed];
    };
    self.tableTabView.rightButtonClickedHandle = ^{
        [weakSelf changeToSerivice];
    };
    
    self.tableView.tableHeaderView = headerView;
}

- (void)changeToNeed
{
    if (self.tabType == 1) {
        return;
    }
    self.tabType = 1;
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNeedSource)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNeed)];
    [self requestNeedSource];
}

- (void)changeToSerivice
{
    if (self.tabType == 2) {
        return;
    }
    self.tabType = 2;
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestServiceSource)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreService)];
    [self requestServiceSource];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tabType == 1) {
        
        if (self.needSource.count == 0) {
            self.nodataLabel.hidden = NO;
        }else{
            self.nodataLabel.hidden = YES;
        }
        
        return self.needSource.count;
    }else{
        
        if (self.serviceSource.count == 0) {
            self.nodataLabel.hidden = NO;
        }else{
            self.nodataLabel.hidden = YES;
        }
        
        return self.serviceSource.count;
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
        
        FRMySeriviceModel * model = [self.serviceSource objectAtIndex:indexPath.row];
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
        FRMySeriviceModel * model = [self.serviceSource objectAtIndex:indexPath.row];
        FRServiceDetailViewController * service = [[FRServiceDetailViewController alloc] initWithSeriviceModel:model];
        [self.navigationController pushViewController:service animated:YES];
    }
}

- (NSMutableArray *)needSource
{
    if (!_needSource) {
        _needSource = [[NSMutableArray alloc] init];
    }
    return _needSource;
}

- (NSMutableArray *)serviceSource
{
    if (!_serviceSource) {
        _serviceSource = [[NSMutableArray alloc] init];
    }
    return _serviceSource;
}

- (NSMutableArray *)bannerSource
{
    if (!_bannerSource) {
        _bannerSource = [[NSMutableArray alloc] init];
    }
    return _bannerSource;
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

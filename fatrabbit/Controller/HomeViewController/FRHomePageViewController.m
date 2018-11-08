//
//  FRHomePageViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRHomePageViewController.h"
#import <SDCycleScrollView.h>
#import "FRCityViewController.h"
#import "FRNavAutoView.h"
#import "FRTableTabView.h"
#import "FRServiceTableViewCell.h"
#import "FRNeedTableViewCell.h"
#import "FRNeedDetailViewController.h"
#import "FRSearchViewController.h"
#import "FRServiceDetailViewController.h"
#import "FRMenuCollectionViewCell.h"
#import "UserManager.h"
#import "FRManager.h"
#import "FRCateListRequest.h"
#import "FRCityListRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRAllCateListViewController.h"
#import "FRCatePageViewController.h"
#import <MJRefresh.h>
#import "FRHomeIndexRequest.h"
#import "FRBannerModel.h"
#import "FRWebViewController.h"
#import "LookImageViewController.h"
#import "FRLoginViewController.h"
#import "FRApplyServicerViewController.h"
#import "FRPublishNeedController.h"

@interface FRHomePageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, FRCityViewControllerDelegate, FRAllCateListViewControllerDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIButton * locationButton;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * needSource;
@property (nonatomic, assign) NSInteger needPage;

@property (nonatomic, strong) NSMutableArray * seriviceSource;
@property (nonatomic, assign) NSInteger serivicePage;

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) NSMutableArray * bannerAdv;
@property (nonatomic, strong) NSMutableArray * cateMenuList;
@property (nonatomic, strong) UICollectionView * menuCollectionView;

@property (nonatomic, strong) FRTableTabView * tableTabView;
@property (nonatomic, assign) NSInteger tabType;

@end

@implementation FRHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    self.tabType = 1;
    [self requestFatrabbitCateInfo];
    [self requestFatrabbitCityInfo];
    [self requestNeedSource];
    [self requestSeriviceSource];
    NSLog(@"%@", FRUserInfoPath);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listDidUpdate) name:FRNeedDidPublishNotification object:nil];
}

- (void)listDidUpdate
{
    if (self.tabType == 1) {
        [self requestNeedSource];
    }else if (self.tabType == 2) {
        [self requestSeriviceSource];
    }
}

//获取分类列表
- (void)requestFatrabbitCateInfo
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:FRCateListPath]) {
        NSArray * data = [NSArray arrayWithContentsOfFile:FRCateListPath];
        [self analysisCateData:data];
    }
    
    FRCateListRequest * request = [[FRCateListRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                NSArray * cate = [data objectForKey:@"cate"];
                if (KIsArray(cate)) {
                    [cate writeToFile:FRCateListPath atomically:YES];
                    [self analysisCateData:cate];
                }
                NSArray * adv = [data objectForKey:@"adv"];
                if (KIsArray(adv)) {
                    self.bannerAdv = [FRBannerModel mj_objectArrayWithKeyValuesArray:adv];
                    
                    [self createTableHeaderView];
                }
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)analysisCateData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        [FRManager shareManager].cateList = [FRCateModel mj_objectArrayWithKeyValuesArray:data];
        [self.cateMenuList removeAllObjects];
        if ([FRManager shareManager].cateList.count >= 8) {
            
            for (NSInteger i = 0; i < 7; i++) {
                FRCateModel * model = [[FRManager shareManager].cateList objectAtIndex:i];
                [self.cateMenuList addObject:model];
            }
            
        }else{
            [self.cateMenuList addObjectsFromArray:[FRManager shareManager].cateList];
        }
        
        [self.menuCollectionView reloadData];
    }
}

//获取城市列表
- (void)requestFatrabbitCityInfo
{
    FRCityListRequest * cityRequest = [[FRCityListRequest alloc] init];
    [cityRequest sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                NSMutableArray * cityList = [[NSMutableArray alloc] init];
                
                for (NSDictionary * dict in data) {
                    FRCityModel * model = [FRCityModel mj_objectWithKeyValues:dict];
                    [cityList addObject:model];
                    if (model.isdefault == 1) {
                        [UserManager shareManager].city = model;
                        [self.locationButton setTitle:model.name forState:UIControlStateNormal];
                    }
                }
                
                [FRManager shareManager].cityList = cityList;
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

//获取需求列表
- (void)requestNeedSource
{
    [self requestFatrabbitCateInfo];
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initNeedWithPage:1];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            [self.needSource removeAllObjects];
            [self.needSource addObjectsFromArray:[FRNeedModel mj_objectArrayWithKeyValuesArray:data]];
            [self.tableView reloadData];
            
            self.needPage = 2;
        }
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreNeed
{
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initNeedWithPage:self.needPage];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data) && data.count > 0) {
                [self.needSource addObjectsFromArray:[FRNeedModel mj_objectArrayWithKeyValuesArray:data]];
                [self.tableView reloadData];
                
                self.needPage++;
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
- (void)requestSeriviceSource
{
    [self requestFatrabbitCateInfo];
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initSeriviceWithPage:1];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            [self.seriviceSource removeAllObjects];
            [self.seriviceSource addObjectsFromArray:[FRMySeriviceModel mj_objectArrayWithKeyValuesArray:data]];
            [self.tableView reloadData];
            
            self.serivicePage = 2;
        }
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreSerivice
{
    FRHomeIndexRequest * request = [[FRHomeIndexRequest alloc] initSeriviceWithPage:self.serivicePage];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data) && data.count > 0) {
                [self.seriviceSource addObjectsFromArray:[FRMySeriviceModel mj_objectArrayWithKeyValuesArray:data]];
                [self.tableView reloadData];
                
                self.serivicePage++;
            }
        }
        [self.tableView.mj_footer endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_footer endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - FRAllCateListViewControllerDelegate
- (void)FRAllCateListViewControllerDidChoose:(FRCateModel *)model
{
    FRCatePageViewController * catePage = [[FRCatePageViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:catePage animated:YES];
}

//选择城市
- (void)locationButtonDicClicked
{
    if (![FRManager shareManager].cityList) {
        [MBProgressHUD showTextHUDWithText:@"正在获取城市信息"];
        [self requestFatrabbitCityInfo];
        return;
    }
    
    FRCityViewController * city = [[FRCityViewController alloc] init];
    city.delegate = self;
    [self.navigationController pushViewController:city animated:YES];
}

- (void)FRCityViewControllerDidChoose:(FRCityModel *)model
{
    [self.locationButton setTitle:model.name forState:UIControlStateNormal];
    [UserManager shareManager].city = model;
    [self listDidUpdate];
}

- (void)searchButtonDidClicked
{
    FRSearchViewController * search = [[FRSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)createViews
{
    FRNavAutoView * navView = [[FRNavAutoView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 20, kNaviBarHeight)];
    self.navigationItem.titleView = navView;
    
    self.locationButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(16) titleColor:UIColorFromRGB(0xFFFFFF) title:@"北京"];
    [self.locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [navView addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.locationButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [self.locationButton addTarget:self action:@selector(locationButtonDicClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cityButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [cityButton setImage:[UIImage imageNamed:@"cityDown"] forState:UIControlStateNormal];
    [navView addSubview:cityButton];
    [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationButton.mas_right).offset(4);
        make.centerY.mas_equalTo(self.locationButton);
        make.width.height.mas_equalTo(10);
    }];
    
    UIButton * searchButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xFFFFFF) title:@""];
    searchButton.backgroundColor = [UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:.4f];
    [navView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-3);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f * 3.f);
        make.height.mas_equalTo(30);
    }];
    [FRCreateViewTool cornerView:searchButton radius:15];
    [searchButton addTarget:self action:@selector(searchButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * searchLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0xffffff) alignment:NSTextAlignmentLeft];
    searchLabel.text = @" 搜索企业/服务/案例/分类等，专业团队";
    [searchButton addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRServiceTableViewCell class] forCellReuseIdentifier:@"FRServiceTableViewCell"];
    [self.tableView registerClass:[FRNeedTableViewCell class] forCellReuseIdentifier:@"FRNeedTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNeedSource)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNeed)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTableHeaderView) name:FRUserLoginStatusDidChange object:nil];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 380 * scale)];
    
    NSMutableArray * images = [[NSMutableArray alloc] init];
    for (FRBannerModel * model in self.bannerAdv) {
        [images addObject:model.img];
    }
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 150 * scale) imageURLStringsGroup:images];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.placeholderImage = [UIImage imageNamed:@"defaultTopBanner"];
    self.bannerView.delegate = self;
    self.bannerView.autoScrollTimeInterval = 3.f;
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150 * scale);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(60 * scale, 75 * scale);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = (kMainBoundsWidth - 60 * scale * 4) / 5.f;
    
    self.menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.menuCollectionView registerClass:[FRMenuCollectionViewCell class] forCellWithReuseIdentifier:@"FRMenuCollectionViewCell"];
    self.menuCollectionView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.dataSource = self;
    self.menuCollectionView.scrollEnabled = NO;
    self.menuCollectionView.contentInset = UIEdgeInsetsMake(10 * scale, (kMainBoundsWidth - 60 * scale * 4) / 5.f, 0, (kMainBoundsWidth - 60 * scale * 4) / 5.f);
    [headerView addSubview:self.menuCollectionView];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo((kMainBoundsWidth / 8.f + 25 * scale) * 2 + 10 + 20 * scale);
    }];
    
    if ([UserManager shareManager].is_provider == 0) {
        headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 440 * scale);
        
        UIView * buttonView = [[UIView alloc] initWithFrame:CGRectZero];
        buttonView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [headerView addSubview:buttonView];
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.menuCollectionView.mas_bottom).offset(10 * scale);
            make.left.mas_equalTo(25 * scale);
            make.width.mas_equalTo(kMainBoundsWidth - 50 * scale);
            make.height.mas_equalTo(40 * scale);
        }];
        buttonView.layer.cornerRadius = kMainBoundsWidth / 10.f / 2.f;
        buttonView.layer.shadowColor = KThemeColor.CGColor;
        buttonView.layer.shadowOpacity = .3f;
        buttonView.layer.shadowRadius = 6 * scale;
        buttonView.layer.shadowOffset = CGSizeMake(0, 3 * scale);
        
        UIButton * becomeButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangMedium(15 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"申请成为服务商，为5000+餐饮酒店提供服务"];
        becomeButton.backgroundColor = KThemeColor;
        [buttonView addSubview:becomeButton];
        [becomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [FRCreateViewTool cornerView:becomeButton radius:20 * scale];
        [becomeButton addTarget:self action:@selector(becomButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.tableTabView = [[FRTableTabView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:self.tableTabView];
    [self.tableTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10 * scale);
        make.height.mas_equalTo(50 * scale);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.tableTabView.leftButtonClickedHandle = ^{
        [weakSelf changeToNeed];
    };
    self.tableTabView.rightButtonClickedHandle = ^{
        [weakSelf changeToSerivice];
    };
    
    if (self.tabType == 2) {
        [self.tableTabView changeService];
    }
    
    self.tableView.tableHeaderView = headerView;
    
    [self requestFatrabbitCityInfo];
}

- (void)becomButtonDidClicked
{
    if ([UserManager shareManager].isLogin) {
        FRApplyServicerViewController * apply = [[FRApplyServicerViewController alloc] init];
        [self.navigationController pushViewController:apply animated:YES];
    }else{
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)changeToNeed
{
    if (self.tabType == 1) {
        return;
    }
    self.tabType = 1;
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNeedSource)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNeed)];
    [self requestNeedSource];
}

- (void)changeToSerivice
{
    if (self.tabType == 2) {
        return;
    }
    self.tabType = 2;
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestSeriviceSource)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSerivice)];
    [self requestSeriviceSource];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tabType == 1) {
        return self.needSource.count;
    }
    return self.seriviceSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tabType == 1) {
        FRNeedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRNeedTableViewCell" forIndexPath:indexPath];
        
        FRNeedModel * model = [self.needSource objectAtIndex:indexPath.row];
        [cell configWithModel:model];
        
        return cell;
    }
    FRServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRServiceTableViewCell" forIndexPath:indexPath];
    
    FRMySeriviceModel * model = [self.seriviceSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * kMainBoundsWidth / 375.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tabType == 1) {
        FRNeedModel * model = [self.needSource objectAtIndex:indexPath.row];
        FRNeedDetailViewController * detail = [[FRNeedDetailViewController alloc] initWithNeedModel:model];
        [self.navigationController pushViewController:detail animated:YES];
    }else if (self.tabType == 2) {
        FRMySeriviceModel * model = [self.seriviceSource objectAtIndex:indexPath.row];
        FRServiceDetailViewController * detail = [[FRServiceDetailViewController alloc] initWithSeriviceModel:model];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cateMenuList.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRMenuCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.item == self.cateMenuList.count) {
        [cell configLastHomeCate];
    }else{
        FRCateModel * model = [self.cateMenuList objectAtIndex:indexPath.item];
        [cell configWithCateModel:model];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.cateMenuList.count) {
        FRAllCateListViewController * allCate = [[FRAllCateListViewController alloc] init];
        allCate.delegate = self;
        [self presentViewController:allCate animated:YES completion:nil];
    }else {
        FRCateModel * model = [self.cateMenuList objectAtIndex:indexPath.item];
        FRCatePageViewController * catePage = [[FRCatePageViewController alloc] initWithModel:model];
        [self.navigationController pushViewController:catePage animated:YES];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    FRBannerModel * model = [self.bannerAdv objectAtIndex:index];
    if (model.type == 0) {
        LookImageViewController * look = [[LookImageViewController alloc] initWithImageURL:model.img];
        [self presentViewController:look animated:YES completion:nil];
    }else if (model.type == 1) {
        FRWebViewController * web = [[FRWebViewController alloc] initWithTitle:@"详情" url:model.param];
        [self.navigationController pushViewController:web animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (NSMutableArray *)cateMenuList
{
    if (!_cateMenuList) {
        _cateMenuList = [[NSMutableArray alloc] init];
    }
    return _cateMenuList;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FRUserLoginStatusDidChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FRNeedDidPublishNotification object:nil];
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

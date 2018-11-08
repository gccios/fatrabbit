//
//  FRStorePageViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStorePageViewController.h"
#import "FRNavAutoView.h"
#import <SDCycleScrollView.h>
#import "FRStoreBannerHeaderView.h"
#import "FRStoreCollectionViewCell.h"
#import "FRTagCollectionHeaderView.h"
#import "FRStoreSearchViewController.h"
#import "FRStoreCartViewController.h"
#import "FRStoreDetailViewController.h"
#import "FRStoreHomeRequest.h"
#import "FRBannerModel.h"
#import "FRStoreBlockModel.h"
#import "FRCateModel.h"
#import "FRChooseSpecView.h"
#import "FRStoreDetailRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "UserManager.h"
#import "FRWebViewController.h"
#import "LookImageViewController.h"
#import "UIButton+Badge.h"
#import <MJRefresh.h>
#import "FRLoginViewController.h"

@interface FRStorePageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) UIButton * storeCartButton;

@property (nonatomic, strong) NSMutableArray * advs;
@property (nonatomic, strong) NSMutableArray * cateList;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRStorePageViewController

- (instancetype)init{
    if (self = [super init]) {
        [self requestStoreInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)reloadPage
{
    [self createViews];
}

- (void)requestStoreInfo
{
    [FRStoreHomeRequest cancelRequest];
    FRStoreHomeRequest * request = [[FRStoreHomeRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                
                NSArray * advs = [data objectForKey:@"adv"];
                if (KIsArray(advs)) {
                    [self.advs removeAllObjects];
                    [self.advs addObjectsFromArray:[FRBannerModel mj_objectArrayWithKeyValuesArray:advs]];
                }
                
                NSArray * cate = [data objectForKey:@"cate"];
                if (KIsArray(cate)) {
                    [self.cateList removeAllObjects];
                    [self.cateList addObjectsFromArray:[FRCateModel mj_objectArrayWithKeyValuesArray:cate]];
                }
                
                NSArray * product = [data objectForKey:@"product"];
                if (KIsArray(product)) {
                    [self.dataSource removeAllObjects];
                    [self.dataSource addObjectsFromArray:[FRStoreBlockModel mj_objectArrayWithKeyValuesArray:product]];
                }
                
            }
            
            [self reloadPage];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)searchButtonDidClicked
{
    FRStoreSearchViewController * search = [[FRStoreSearchViewController alloc] initWithCateModel:nil cateList:self.cateList];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)searchWithModel:(FRCateModel *)model
{
    FRStoreSearchViewController * search = [[FRStoreSearchViewController alloc] initWithCateModel:model cateList:self.cateList];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)storeCartButtonDidClicked
{
    if (![UserManager shareManager].isLogin) {
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    FRStoreCartViewController * cart = [[FRStoreCartViewController alloc] init];
    [self.navigationController pushViewController:cart animated:YES];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    FRNavAutoView * navView = [[FRNavAutoView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 20, kNaviBarHeight)];
    self.navigationItem.titleView = navView;
    
    UIButton * searchButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xFFFFFF) title:@""];
    searchButton.backgroundColor = [UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:.4f];
    [navView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20 * scale);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f * 3.f);
        make.height.mas_equalTo(30);
    }];
    [FRCreateViewTool cornerView:searchButton radius:15];
    [searchButton addTarget:self action:@selector(searchButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.storeCartButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@""];
    [self.storeCartButton setImage:[UIImage imageNamed:@"navStoreCart"] forState:UIControlStateNormal];
    [navView addSubview:self.storeCartButton];
    [self.storeCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0 * scale);
        make.width.mas_equalTo(40 * scale);
    }];
    [self.storeCartButton addTarget:self action:@selector(storeCartButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * searchLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0xffffff) alignment:NSTextAlignmentLeft];
    searchLabel.text = @" 搜索商品名称";
    [searchButton addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kMainBoundsWidth / 2.f, 200 * scale);
    layout.minimumLineSpacing = 5 * scale;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[FRStoreCollectionViewCell class] forCellWithReuseIdentifier:@"FRStoreCollectionViewCell"];
    [self.collectionView registerClass:[FRStoreBannerHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRStoreBannerHeaderView"];
    [self.collectionView registerClass:[FRTagCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRTagCollectionHeaderView"];
    self.collectionView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestStoreInfo)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRStoreBlockModel * block = [self.dataSource objectAtIndex:indexPath.section];
    FRStoreModel * model = [block.list objectAtIndex:indexPath.item];
    
    FRStoreDetailViewController * detail = [[FRStoreDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    FRStoreBlockModel * model = [self.dataSource objectAtIndex:section];
    
    return model.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRStoreCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRStoreCollectionViewCell" forIndexPath:indexPath];
    
    FRStoreBlockModel * block = [self.dataSource objectAtIndex:indexPath.section];
    FRStoreModel * model = [block.list objectAtIndex:indexPath.item];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.storeCartHandle = ^{
        [weakSelf showChooseSpecWith:model];
    };
    
    return cell;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            
            FRStoreBannerHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRStoreBannerHeaderView" forIndexPath:indexPath];
            [view configWithBannerSource:self.advs];
            [view configCateSource:self.cateList];
            view.bannerView.delegate = self;
            
            __weak typeof(self) weakSelf = self;
            view.menuDidClickedHandle = ^(FRCateModel *model) {
                if (model) {
                    [weakSelf searchWithModel:model];
                }
            };
            
            FRStoreBlockModel * block = [self.dataSource objectAtIndex:indexPath.section];
            [view configWithTitle:block.label_title];
            view.moreDidClickedHandle = ^{
                [weakSelf searchWithFRStoreBlockModel:block];
            };
            
            return view;
        }else{
            
            FRTagCollectionHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRTagCollectionHeaderView" forIndexPath:indexPath];
            
            FRStoreBlockModel * block = [self.dataSource objectAtIndex:indexPath.section];
            [view configWithTitle:block.label_title];
            __weak typeof(self) weakSelf = self;
            view.moreDidClickedHandle = ^{
                [weakSelf searchWithFRStoreBlockModel:block];
            };
            
            return view;
        }
        
    }
    return nil;
}

- (void)searchWithFRStoreBlockModel:(FRStoreBlockModel *)model
{
    FRStoreSearchViewController * search = [[FRStoreSearchViewController alloc] initWithStoreBlockModel:model cateList:self.cateList];
    [self.navigationController pushViewController:search animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (section == 0) {
        return CGSizeMake(kMainBoundsWidth, 380 * scale);
    }
    return CGSizeMake(kMainBoundsWidth, 60 * scale);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    FRBannerModel * model = [self.advs objectAtIndex:index];
    if (model.type == 0) {
        LookImageViewController * look = [[LookImageViewController alloc] initWithImageURL:model.img];
        [self presentViewController:look animated:YES completion:nil];
    }else if (model.type == 1) {
        FRWebViewController * web = [[FRWebViewController alloc] initWithTitle:@"详情" url:model.param];
        [self.navigationController pushViewController:web animated:YES];
    }
}

- (NSMutableArray *)advs
{
    if (!_advs) {
        _advs = [[NSMutableArray alloc] init];
    }
    return _advs;
}

- (NSMutableArray *)cateList
{
    if (!_cateList) {
        _cateList = [[NSMutableArray alloc] init];
    }
    return _cateList;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataSource.count == 0) {
        [self requestStoreInfo];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.storeCartButton setBadgeValue:[NSString stringWithFormat:@"%ld", [UserManager shareManager].storeCart.count]];
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

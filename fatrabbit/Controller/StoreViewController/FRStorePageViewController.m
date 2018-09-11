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

@interface FRStorePageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) SDCycleScrollView * bannerView;

@property (nonatomic, strong) NSMutableArray * advs;
@property (nonatomic, strong) NSMutableArray * cateList;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRStorePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestStoreInfo];
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
    FRStoreSearchViewController * storeSearch = [[FRStoreSearchViewController alloc] init];
    [self.navigationController pushViewController:storeSearch animated:YES];
}

- (void)storeCartButtonDidClicked
{
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
    
    UIButton * storeCartButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"购物车"];
    [navView addSubview:storeCartButton];
    [storeCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0 * scale);
        make.width.mas_equalTo(60 * scale);
    }];
    [storeCartButton addTarget:self action:@selector(storeCartButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * searchLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    searchLabel.text = @"搜索企业/服务/案例/分类等，专业团队";
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
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            
            FRStoreBannerHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRStoreBannerHeaderView" forIndexPath:indexPath];
            [view configWithBannerSource:self.advs];
            [view configCateSource:self.cateList];
            
            return view;
        }else{
            
            FRTagCollectionHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRTagCollectionHeaderView" forIndexPath:indexPath];
            
            FRStoreBlockModel * block = [self.dataSource objectAtIndex:indexPath.section];
            [view configWithTitle:block.label_title];
            
            return view;
        }
        
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (section == 0) {
        return CGSizeMake(kMainBoundsWidth, 310 * scale);
    }
    return CGSizeMake(kMainBoundsWidth, 60 * scale);
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

//
//  FRCityViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCityViewController.h"
#import "FRCityListRequest.h"
#import "FRCityCollectionViewCell.h"
#import "FRCityFooterView.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRUserReportCityRequest.h"

@interface FRCityViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * cityArray;
@property (nonatomic, strong) UICollectionView * cityCollectionView;

@property (nonatomic, assign) BOOL isProvideChoose;

@end

@implementation FRCityViewController

- (instancetype)initWithProvideChoose
{
    if (self = [super init]) {
        self.isProvideChoose = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cityArray = [[NSMutableArray alloc] init];
    
    [self.cityArray addObjectsFromArray:[FRManager shareManager].cityList];
    if (self.isProvideChoose) {
        FRCityModel * model = [[FRCityModel alloc] init];
        model.cid = 0;
        model.name = @"全国";
        [self.cityArray insertObject:model atIndex:0];
    }
    
    [self createViews];
    
    [self requestCityList];
}

- (void)requestCityList
{
//    FRCityListRequest * request = [[FRCityListRequest alloc] init];
//    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
//
//    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
//
//    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
//
//    }];
}

- (void)createViews
{
    self.navigationItem.title = @"选择城市";
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UILabel * topTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    topTipLabel.text = @"已开通城市";
    [self.view addSubview:topTipLabel];
    [topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kMainBoundsWidth / 12.f * 3, 45 * scale);
    layout.minimumLineSpacing = 10 * scale;
    layout.minimumInteritemSpacing = kMainBoundsWidth / 20.f;
    layout.footerReferenceSize = CGSizeMake(kMainBoundsWidth, 50 * scale);
    
    self.cityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.cityCollectionView registerClass:[FRCityCollectionViewCell class] forCellWithReuseIdentifier:@"FRCityCollectionViewCell"];
    [self.cityCollectionView registerClass:[FRCityFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FRCityFooterView"];
    self.cityCollectionView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.cityCollectionView.delegate = self;
    self.cityCollectionView.dataSource = self;
    self.cityCollectionView.contentInset = UIEdgeInsetsMake(0, kMainBoundsWidth / 15.f, 0, kMainBoundsWidth / 15.f);
    [self.view addSubview:self.cityCollectionView];
    [self.cityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50 * scale);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(FRCityViewControllerDidChoose:)]) {
        FRCityModel * model = [self.cityArray objectAtIndex:indexPath.row];
        if (self.isProvideChoose) {
            [self.delegate FRCityViewControllerDidChoose:model];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在切换当前城市" inView:self.view];
        FRUserReportCityRequest * request = [[FRUserReportCityRequest alloc] initWithCityID:model.cid];
        
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            [self.delegate FRCityViewControllerDidChoose:model];
            [self.navigationController popViewControllerAnimated:YES];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
            
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRCityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRCityCollectionViewCell" forIndexPath:indexPath];
    
    FRCityModel * model = [self.cityArray objectAtIndex:indexPath.row];
    [cell congitWithModel:model];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        FRCityFooterView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FRCityFooterView" forIndexPath:indexPath];
        
        return view;
    }
    
    return nil;
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

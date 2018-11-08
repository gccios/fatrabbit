//
//  FRStoreBannerHeaderView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreBannerHeaderView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import "FRMenuCollectionViewCell.h"
#import "FRBannerModel.h"

@interface FRStoreBannerHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) NSMutableArray * bannerSource;
@property (nonatomic, weak) NSMutableArray * cateSource;

@property (nonatomic, strong) UICollectionView * menuCollectionView;
@property (nonatomic, strong) UILabel * tagLabel;

@end

@implementation FRStoreBannerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createStoreBannerHeaderView];
    }
    return self;
}

- (void)moreButtonDidClicked
{
    if (self.moreDidClickedHandle) {
        self.moreDidClickedHandle();
    }
}

- (void)configWithTitle:(NSString *)title
{
    self.tagLabel.text = title;
}

- (void)configWithBannerSource:(NSMutableArray *)bannerSource
{
    if (bannerSource.count == 0) {
        return;
    }
    
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
    
    self.bannerSource = bannerSource;
    NSMutableArray * imageURLList = [[NSMutableArray alloc] init];
    for (FRBannerModel * model in self.bannerSource) {
        [imageURLList addObject:model.img];
    }
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 150 * scale) imageURLStringsGroup:imageURLList];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.placeholderImage = [UIImage imageNamed:@"defaultTopBanner"];
    self.bannerView.autoScrollTimeInterval = 3.f;
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150 * scale);
    }];
}

- (void)configCateSource:(NSMutableArray *)cateSource
{
    if (cateSource.count == 0) {
        return;
    }
    
    self.cateSource = cateSource;
    [self.menuCollectionView reloadData];
}

- (void)createStoreBannerHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 150 * scale) imageURLStringsGroup:@[]];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.placeholderImage = [UIImage imageNamed:@"defaultTopBanner"];
    self.bannerView.autoScrollTimeInterval = 3.f;
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150 * scale);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(60 * scale, 75 * scale);
    layout.minimumLineSpacing = 10 * scale;
    layout.minimumInteritemSpacing = (kMainBoundsWidth - 60 * scale * 4) / 5.f;
    
    self.menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.menuCollectionView registerClass:[FRMenuCollectionViewCell class] forCellWithReuseIdentifier:@"FRMenuCollectionViewCell"];
    self.menuCollectionView.backgroundColor = self.backgroundColor;
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.dataSource = self;
    self.menuCollectionView.scrollEnabled = NO;
    self.menuCollectionView.contentInset = UIEdgeInsetsMake(10 * scale, (kMainBoundsWidth - 60 * scale * 4) / 5.f - 1, 0, (kMainBoundsWidth - 60 * scale * 4) / 5.f - 1);
    [self addSubview:self.menuCollectionView];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(155 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(170 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = KThemeColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10 * scale);
        make.left.mas_equalTo(20 * scale);
        make.width.mas_equalTo(4 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    
    self.tagLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(17 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    [self addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView);
        make.left.mas_equalTo(lineView.mas_right).offset(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIButton * moreButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:KThemeColor title:@"更多>>"];
    [moreButton addTarget:self action:@selector(moreButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tagLabel);
        make.right.mas_equalTo(-20 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.cateSource.count > 8) {
        return 8;
    }
    return self.cateSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRMenuCollectionViewCell" forIndexPath:indexPath];
    
//    if (indexPath.item == self.cateSource.count) {
//        [cell configLastStoreCate];
//    }else{
//        FRCateModel * model = [self.cateSource objectAtIndex:indexPath.item];
//        [cell configWithCateModel:model];
//    }
    FRCateModel * model = [self.cateSource objectAtIndex:indexPath.item];
    [cell configWithCateModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menuDidClickedHandle) {
//        if (indexPath.item == self.cateSource.count) {
//            self.menuDidClickedHandle(nil);
//        }else{
//            FRCateModel * model = [self.cateSource objectAtIndex:indexPath.item];
//            self.menuDidClickedHandle(model);
//        }
        FRCateModel * model = [self.cateSource objectAtIndex:indexPath.item];
        self.menuDidClickedHandle(model);
    }
}

@end

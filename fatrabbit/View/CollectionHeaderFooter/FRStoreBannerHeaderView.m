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
#import <SDCycleScrollView.h>
#import "FRMenuCollectionViewCell.h"

@interface FRStoreBannerHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SDCycleScrollView * bannerView;
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

- (void)createStoreBannerHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.backgroundColor = UIColorFromRGB(0xEFEFF4);
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:@[@"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg"]];
    self.bannerView.autoScrollTimeInterval = 3.f;
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kMainBoundsWidth / 7.f * 3);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(60 * scale, 75 * scale);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = (kMainBoundsWidth - 60 * scale * 5) / 6.f;
    
    self.menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.menuCollectionView registerClass:[FRMenuCollectionViewCell class] forCellWithReuseIdentifier:@"FRMenuCollectionViewCell"];
    self.menuCollectionView.backgroundColor = self.backgroundColor;
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.dataSource = self;
    self.menuCollectionView.scrollEnabled = NO;
    self.menuCollectionView.contentInset = UIEdgeInsetsMake(10 * scale, (kMainBoundsWidth - 60 * scale * 5) / 6.f - 1, 0, (kMainBoundsWidth - 60 * scale * 5) / 6.f - 1);
    [self addSubview:self.menuCollectionView];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100 * scale);
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
    self.tagLabel.text = @"热卖推荐";
    [self addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView);
        make.left.mas_equalTo(lineView.mas_right).offset(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRMenuCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

@end
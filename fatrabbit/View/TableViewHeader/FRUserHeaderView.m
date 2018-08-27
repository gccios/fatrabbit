//
//  FRUserHeaderView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserHeaderView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRUserHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * notLoginLabel;

@property (nonatomic, strong) UIView * userView;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation FRUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUserHeaderView];
    }
    return self;
}

- (void)createUserHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    self.userView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(110 * scale);
    }];
    
    self.logoImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.logoImageView.backgroundColor = [UIColor greenColor];
    [self.userView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(60 * scale);
    }];
    [FRCreateViewTool cornerView:self.logoImageView radius:30 * scale];
    
    self.notLoginLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(17 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.notLoginLabel.text = @"未登录";
    [self.userView addSubview:self.notLoginLabel];
    [self.notLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(10 * scale);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(30 * scale);
    }];
    
    [self createHandleView];
}

- (void)createHandleView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kMainBoundsWidth - kMainBoundsWidth / 16.f * 5) / 4.f, kMainBoundsWidth / 8.f + 25 * scale);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = kMainBoundsWidth / 16.f;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.collectionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(90 * scale);
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(10 * scale, kMainBoundsWidth / 16.f, 0, kMainBoundsWidth / 16.f);
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [self.userView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(.5);
        make.width.mas_equalTo(kMainBoundsWidth - 40 * scale);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}


@end

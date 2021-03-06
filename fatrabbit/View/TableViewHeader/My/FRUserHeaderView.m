//
//  FRUserHeaderView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserHeaderView.h"
#import "FRCreateViewTool.h"
#import "UserManager.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRUserHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * notLoginLabel;

@property (nonatomic, strong) UIView * userView;

@property (nonatomic, strong) UIView * infoView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * provideImageView;
@property (nonatomic, strong) UILabel * levelLabel;
@property (nonatomic, strong) UIProgressView * levelProgressView;
@property (nonatomic, strong) UILabel * vipLabel;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUserHeaderView];
    }
    return self;
}

- (void)userInfoDidClicked
{
    if (self.userInfoDidClickedHandle) {
        self.userInfoDidClickedHandle();
    }
}

- (void)userLoginStatusChange
{
    if ([UserManager shareManager].isLogin) {
        self.infoView.hidden = NO;
        
        self.nameLabel.text = [UserManager shareManager].nickname;
        self.vipLabel.text = [UserManager shareManager].vip_name;
        self.levelLabel.text = [NSString stringWithFormat:@"%.2lf", [UserManager shareManager].points];
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager shareManager].avatar]];
        if (isEmptyString([UserManager shareManager].avatar)) {
            [self.logoImageView setImage:[UIImage imageNamed:@"defalutLogo"]];
        }
        
        if ([UserManager shareManager].is_provider == 1) {
            self.provideImageView.hidden = NO;
        }else{
            self.provideImageView.hidden = YES;
        }
        self.levelProgressView.progress = [UserManager shareManager].next_vip_percent;
        
    }else{
        self.infoView.hidden = YES;
        [self.logoImageView setImage:[UIImage imageNamed:@"defalutLogo"]];
    }
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
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoDidClicked)];
    [self.userView addGestureRecognizer:tap];
    
    self.logoImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.logoImageView.backgroundColor = UIColorFromRGB(0xf5f5f5);
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
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infoView.backgroundColor = self.backgroundColor;
    [self.userView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth - 80 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.infoView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25 * scale);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.provideImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"userProvide"]];
    [self.infoView addSubview:self.provideImageView];
    [self.provideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(5 * scale);
        make.width.mas_equalTo(30 * scale);
        make.height.mas_equalTo(13 * scale);
    }];
    
    UILabel * levelTip = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    levelTip.text = @"积分：";
    [self.infoView addSubview:levelTip];
    [levelTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.levelLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [self.infoView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(levelTip);
        make.left.mas_equalTo(levelTip.mas_right);
        make.height.mas_equalTo(levelTip);
    }];
    
    self.levelProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.levelProgressView.progressTintColor = UIColorFromRGB(0xf1e632);
    self.levelProgressView.tintColor = UIColorFromRGB(0xeeeeee);
    self.levelProgressView.progress = [UserManager shareManager].next_vip_percent;
    [self.infoView addSubview:self.levelProgressView];
    [self.levelProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(levelTip.mas_bottom).offset(5 * scale);
        make.height.mas_equalTo(10 * scale);
        make.left.mas_equalTo(levelTip);
        make.width.mas_equalTo(180 * scale);
    }];
    [FRCreateViewTool cornerView:self.levelProgressView radius:5 * scale];
    
    self.vipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    [self.infoView addSubview:self.vipLabel];
    [self.vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.levelProgressView.mas_right).offset(5 * scale);
        make.centerY.mas_equalTo(self.levelProgressView);
        make.height.mas_equalTo(15 * scale);
    }];
    
    [self createHandleView];
}

- (void)createHandleView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObject:[[FRUserHeaderMenuModel alloc] initWithType:FRUserHeaderMenuType_Order]];
    [self.dataSource addObject:[[FRUserHeaderMenuModel alloc] initWithType:FRUserHeaderMenuType_Collect]];
    [self.dataSource addObject:[[FRUserHeaderMenuModel alloc] initWithType:FRUserHeaderMenuType_Need]];
    [self.dataSource addObject:[[FRUserHeaderMenuModel alloc] initWithType:FRUserHeaderMenuType_VIP]];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kMainBoundsWidth - kMainBoundsWidth / 16.f * 5) / 4.f, kMainBoundsWidth / 8.f + 25 * scale);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = kMainBoundsWidth / 16.f;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[FRMyMenuCollectionViewCell class] forCellWithReuseIdentifier:@"FRMyMenuCollectionViewCell"];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStatusChange) name:FRUserLoginStatusDidChange object:nil];
    [self userLoginStatusChange];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRMyMenuCollectionViewCell" forIndexPath:indexPath];
    
    FRUserHeaderMenuModel * model = [self.dataSource objectAtIndex:indexPath.item];
    [cell configWithModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRUserHeaderMenuModel * model = [self.dataSource objectAtIndex:indexPath.item];
    if (self.userHeaderMenuDidClickedHandle) {
        self.userHeaderMenuDidClickedHandle(model);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FRUserLoginStatusDidChange object:nil];
}

@end

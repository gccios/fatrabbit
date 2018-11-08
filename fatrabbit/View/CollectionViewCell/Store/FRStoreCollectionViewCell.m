//
//  FRStoreCollectionViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreCollectionViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRStoreCollectionViewCell ()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIButton * buyButton;

@end

@implementation FRStoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createStoreCell];
    }
    return self;
}

- (void)buyButtonDidClicked
{
    if (self.storeCartHandle) {
        self.storeCartHandle();
    }
}

- (void)configWithModel:(FRStoreModel *)model
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.price];
    if (model.is_points) {
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f 积分", model.price];
    }
}

- (void)createStoreCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.contentView addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5 * scale);
        make.left.mas_equalTo(5 * scale);
        make.bottom.mas_equalTo(-5 * scale);
        make.right.mas_equalTo(-5 * scale);
    }];
    [FRCreateViewTool cornerView:baseView radius:15 * scale];
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.clipsToBounds = YES;
    [baseView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(10 * scale);
        make.right.mas_equalTo(-10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    [baseView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15 * scale);
        make.left.mas_equalTo(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.buyButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@""];
    [baseView addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(25 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    [self.buyButton addTarget:self action:@selector(buyButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.buyButton.hidden = YES;
    
    UIImageView * buyImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"storeCart"]];
    [self.buyButton addSubview:buyImageView];
    [buyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(17 * scale);
    }];
}

@end

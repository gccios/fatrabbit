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

- (void)createStoreCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.contentView addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(-5 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    [FRCreateViewTool cornerView:baseView radius:15 * scale];
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.backgroundColor = [UIColor greenColor];
    [baseView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"测试商品标题";
    [baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(10 * scale);
        make.right.mas_equalTo(-10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * price = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    price.text = @"￥";
    [baseView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15 * scale);
        make.left.mas_equalTo(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = @"测试金额";
    [baseView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(price);
        make.left.mas_equalTo(price.mas_right);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.buyButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@""];
    self.buyButton.backgroundColor = [UIColor greenColor];
    [baseView addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.priceLabel);
        make.width.mas_equalTo(25 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
}

@end

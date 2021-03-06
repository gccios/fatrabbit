//
//  FRMenuCollectionViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMenuCollectionViewCell.h"
#import "FRCreateViewTool.h"
#import "FRCateModel.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRMenuCollectionViewCell ()

@property (nonatomic, strong) UIImageView * menuImageView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation FRMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createMenuCollectionViewCell];
    }
    return self;
}

- (void)configLastHomeCate
{
    [self.menuImageView setImage:[UIImage imageNamed:@"allCate"]];
    self.titleLabel.text = @"全部分类";
}

- (void)configLastStoreCate
{
    [self.menuImageView setImage:[UIImage imageNamed:@"levelChange"]];
    self.titleLabel.text = @"积分兑换";
}

- (void)configWithCateModel:(FRCateModel *)model
{
    [self.menuImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.titleLabel.text = model.name;
}

- (void)createMenuCollectionViewCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.menuImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    [self.contentView addSubview:self.menuImageView];
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5 * scale);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(50 * scale);
    }];
    [FRCreateViewTool cornerView:self.menuImageView radius:25 * scale];
    
    self.titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(15 * scale);
    }];
}

@end

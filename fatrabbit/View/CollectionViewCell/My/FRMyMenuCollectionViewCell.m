//
//  FRMyMenuCollectionViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyMenuCollectionViewCell.h"
#import "FRCreateViewTool.h"
#import "FRCateModel.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRMyMenuCollectionViewCell ()

@property (nonatomic, strong) FRUserHeaderMenuModel * model;
@property (nonatomic, strong) UIImageView * menuImageView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation FRMyMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createMenuCollectionViewCell];
    }
    return self;
}

- (void)configWithModel:(FRUserHeaderMenuModel *)model
{
    self.model = model;
    
    [self.menuImageView setImage:[UIImage imageNamed:model.imageName]];
    self.titleLabel.text = model.title;
}

- (void)createMenuCollectionViewCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.menuImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    [self.contentView addSubview:self.menuImageView];
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(25 * scale);
    }];
    
    self.titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
}

@end

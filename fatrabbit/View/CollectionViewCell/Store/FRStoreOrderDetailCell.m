//
//  FRStoreOrderDetailCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreOrderDetailCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRStoreOrderDetailCell ()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation FRStoreOrderDetailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createOrderDetailCell];
    }
    return self;
}

- (void)configWithModel:(FRStoreCartModel *)model
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    NSString * totalNumber = @"";
    if (model.num > 9) {
        
        if (model.num > 99) {
            totalNumber = @"99+";
        }else{
            totalNumber = [NSString stringWithFormat:@"%ld", model.num];
        }
        
        [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30 * scale);
        }];
    }else{
        totalNumber = [NSString stringWithFormat:@"%ld", model.num];
        [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20 * scale);
        }];
    }
    self.numberLabel.text = totalNumber;
}

- (void)createOrderDetailCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-10 * scale);
        make.bottom.mas_equalTo(0);
    }];
    [FRCreateViewTool cornerView:self.coverImageView radius:5 * scale];
    
    self.numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0xffffff) alignment:NSTextAlignmentCenter];
    self.numberLabel.text = @"1";
    self.numberLabel.backgroundColor = KPriceColor;
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(20 * scale);
    }];
    [FRCreateViewTool cornerView:self.numberLabel radius:10 * scale];
}

@end

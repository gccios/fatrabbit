//
//  FRStoreTagCollectionViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/14.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreTagCollectionViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRStoreTagCollectionViewCell ()

@property (nonatomic, strong) UILabel * tagLabel;

@end

@implementation FRStoreTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createTagCollectionCell];
    }
    return self;
}

- (void)configWithModel:(FRStoreTagModel *)model
{
    self.tagLabel.text = model.title;
}

- (void)configWithHighLight:(BOOL)lighted
{
    UIColor * color = UIColorFromRGB(0x999999);
    if (lighted) {
        color = KPriceColor;
    }
    self.tagLabel.layer.borderColor = color.CGColor;
    self.tagLabel.layer.borderWidth = .5;
    self.tagLabel.textColor = color;
}

- (void)createTagCollectionCell
{
    self.tagLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    [FRCreateViewTool cornerView:self.tagLabel radius:10];
}

@end

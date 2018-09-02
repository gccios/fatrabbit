//
//  FRTagCollectionHeaderView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRTagCollectionHeaderView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRTagCollectionHeaderView ()

@property (nonatomic, strong) UILabel * tagLabel;

@end

@implementation FRTagCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createTagCollectionHeaderView];
    }
    return self;
}

- (void)createTagCollectionHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
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

@end

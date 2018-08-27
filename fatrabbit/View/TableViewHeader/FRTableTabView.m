//
//  FRTableTabView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRTableTabView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@implementation FRTableTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createTableTabView];
    }
    return self;
}

- (void)createTableTabView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = KThemeColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20 * scale);
        make.width.mas_equalTo(3 * scale);
    }];
    
    UIButton * hotNeed = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangMedium(17 * scale) titleColor:KThemeColor title:@"热门需求"];
    [self addSubview:hotNeed];
    [hotNeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView.mas_right).offset(10 * scale);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(70 * scale);
    }];
    
    UILabel * middleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(20) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    middleLabel.text = @"/";
    [self addSubview:middleLabel];
    [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(hotNeed.mas_right);
    }];
    
    UIButton * hotService = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(17 * scale) titleColor:UIColorFromRGB(0x333333) title:@"热门服务"];
    [self addSubview:hotService];
    [hotService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(middleLabel.mas_right);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(70 * scale);
    }];
}

@end

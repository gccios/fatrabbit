//
//  FRCityFooterView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCityFooterView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@implementation FRCityFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createFRCityFooterView];
    }
    return self;
}

- (void)createFRCityFooterView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0 * scale);
        make.right.mas_equalTo(0 * scale);
        make.height.mas_equalTo(.5);
        make.top.mas_equalTo(5 * scale);
    }];
    
    UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    tipLabel.text = @"其它城市陆续开通中，敬请期待";
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(0 * scale);
        make.right.mas_equalTo(0 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
}

@end

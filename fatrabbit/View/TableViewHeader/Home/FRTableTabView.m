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

@interface FRTableTabView ()

@property (nonatomic, strong) UIButton * hotNeed;
@property (nonatomic, strong) UIButton * hotService;

@property (nonatomic, strong) UIView * progressView;

@end

@implementation FRTableTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createTableTabView];
    }
    return self;
}

- (void)hotNeedDidClicked
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    [self.hotNeed setTitleColor:KThemeColor forState:UIControlStateNormal];
    self.hotNeed.titleLabel.font = kPingFangMedium(15 * scale);
    [self.hotService setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.hotService.titleLabel.font = kPingFangRegular(15 * scale);
    
    [UIView animateWithDuration:.3f animations:^{
        
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25 * scale);
        }];
        [self layoutIfNeeded];
        
    }];
    
    if (self.leftButtonClickedHandle) {
        self.leftButtonClickedHandle();
    }
}

- (void)hotServiceDidClicked
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    [self.hotNeed setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.hotNeed.titleLabel.font = kPingFangRegular(15 * scale);
    [self.hotService setTitleColor:KThemeColor forState:UIControlStateNormal];
    self.hotService.titleLabel.font = kPingFangMedium(15 * scale);
    
    [UIView animateWithDuration:.3f animations:^{
        
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(115 * scale);
        }];
        [self layoutIfNeeded];
        
    }];
    
    if (self.rightButtonClickedHandle) {
        self.rightButtonClickedHandle();
    }
}

- (void)changeService
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    [self.hotNeed setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.hotNeed.titleLabel.font = kPingFangRegular(15 * scale);
    [self.hotService setTitleColor:KThemeColor forState:UIControlStateNormal];
    self.hotService.titleLabel.font = kPingFangMedium(15 * scale);
    
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(115 * scale);
    }];
}

- (void)createTableTabView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.hotNeed = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangMedium(15 * scale) titleColor:KThemeColor title:@"热门需求"];
    [self addSubview:self.hotNeed];
    [self.hotNeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(70 * scale);
    }];
    [self.hotNeed addTarget:self action:@selector(hotNeedDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * middleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(17) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    middleLabel.text = @"|";
    [self addSubview:middleLabel];
    [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(25 * scale);
        make.left.mas_equalTo(self.hotNeed.mas_right);
        make.width.mas_equalTo(20 * scale);
    }];
    
    self.hotService = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0x333333) title:@"热门服务"];
    [self addSubview:self.hotService];
    [self.hotService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(middleLabel.mas_right);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(70 * scale);
    }];
    [self.hotService addTarget:self action:@selector(hotServiceDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectZero];
    self.progressView.backgroundColor = KThemeColor;
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2.f);
        make.width.mas_equalTo(60 * scale);
        make.top.mas_equalTo(self.hotNeed.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(25 * scale);
    }];
}

@end

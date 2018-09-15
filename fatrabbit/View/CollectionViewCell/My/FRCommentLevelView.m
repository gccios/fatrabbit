//
//  FRCommentLevelView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCommentLevelView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRCommentLevelView ()

@end

@implementation FRCommentLevelView

- (instancetype)initWithCommentNormal
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 125 * scale)]) {
        [self createLevelView];
    }
    return self;
}

- (void)showWithServiceLevel:(NSInteger)serviceLevel companyLevel:(NSInteger)companyLevel businessLevel:(NSInteger)businessLevel
{
    self.userInteractionEnabled = NO;
    [self.serviceLevel setSelectedStarIndex:serviceLevel];
    [self.companyLevel setSelectedStarIndex:companyLevel];
    [self.businessLevel setSelectedStarIndex:businessLevel];
}

- (void)configDelegateWith:(id)delegate
{
    self.serviceLevel.delegate = delegate;
    self.companyLevel.delegate = delegate;
    self.businessLevel.delegate = delegate;
}

- (void)createLevelView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * serviceView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:serviceView];
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(30 * scale);
    }];
    
    UILabel * serviceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    serviceLabel.text = @"服务评分：";
    [serviceView addSubview:serviceLabel];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.serviceLevel = [[LMJGradeStarsControl alloc] initWithFrame:CGRectMake(0, 0, 180 * scale, 30 * scale) defaultSelectedStatIndex:0 totalStars:5 starSize:20 * scale];
    [serviceView addSubview:self.serviceLevel];
    [self.serviceLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(serviceLabel.mas_right);
        make.width.mas_equalTo(180 * scale);
    }];
    
    UIView * companyView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:companyView];
    [companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(30 * scale);
    }];
    
    UILabel * companyLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    companyLabel.text = @"公司评分：";
    [companyView addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.companyLevel = [[LMJGradeStarsControl alloc] initWithFrame:CGRectMake(0, 0, 180 * scale, 30 * scale) defaultSelectedStatIndex:0 totalStars:5 starSize:20 * scale];
    [companyView addSubview:self.companyLevel];
    [self.companyLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(companyLabel.mas_right);
        make.width.mas_equalTo(180 * scale);
    }];
    
    UIView * businessView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:businessView];
    [businessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(companyView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(30 * scale);
    }];
    
    UILabel * businessLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    businessLabel.text = @"业务评分：";
    [businessView addSubview:businessLabel];
    [businessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.businessLevel = [[LMJGradeStarsControl alloc] initWithFrame:CGRectMake(0, 0, 180 * scale, 30 * scale) defaultSelectedStatIndex:0 totalStars:5 starSize:20 * scale];
    [businessView addSubview:self.businessLevel];
    [self.businessLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(businessLabel.mas_right);
        make.width.mas_equalTo(180 * scale);
    }];
}

@end

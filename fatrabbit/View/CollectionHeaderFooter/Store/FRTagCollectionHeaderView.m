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

- (void)moreButtonDidClicked
{
    if (self.moreDidClickedHandle) {
        self.moreDidClickedHandle();
    }
}

- (void)configWithTitle:(NSString *)title
{
    self.tagLabel.text = title;
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
    [self addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView);
        make.left.mas_equalTo(lineView.mas_right).offset(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIButton * moreButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:KThemeColor title:@"更多>>"];
    [moreButton addTarget:self action:@selector(moreButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tagLabel);
        make.right.mas_equalTo(-20 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
}

@end

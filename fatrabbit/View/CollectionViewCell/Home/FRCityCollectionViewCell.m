//
//  FRCityCollectionViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCityCollectionViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRCityCollectionViewCell ()

@property (nonatomic, strong) UILabel * cityNameLabel;
@property (nonatomic, strong) FRCityModel * model;

@end

@implementation FRCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createCollectionViewCell];
    }
    return self;
}

- (void)createCollectionViewCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5 * scale);
        make.bottom.right.mas_equalTo(-5 * scale);
    }];
    
//    baseView.layer.cornerRadius = 5 * scale;
//    baseView.layer.shadowColor = [UIColor blackColor].CGColor;
//    baseView.layer.shadowOpacity = .3f;
//    baseView.layer.shadowRadius = 5 * scale;
//    baseView.layer.shadowOffset = CGSizeMake(0, 2 * scale);
    
    self.cityNameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(17 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    self.cityNameLabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [baseView addSubview:self.cityNameLabel];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [FRCreateViewTool cornerView:self.cityNameLabel radius:5 * scale];
}

- (void)congitWithModel:(FRCityModel *)model
{
    self.model = model;
    
    self.cityNameLabel.text = model.name;
}

@end

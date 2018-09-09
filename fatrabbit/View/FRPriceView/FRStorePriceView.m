//
//  FRStorePriceView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStorePriceView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRStorePriceView ()

@property (nonatomic, strong) FRStoreModel * model;
@property (nonatomic, strong) FRStoreSpecModel * specModel;

@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * pointLabel;
@property (nonatomic, strong) UILabel * expressLabel;
@property (nonatomic, strong) UILabel * stockLabel;

@end

@implementation FRStorePriceView

- (instancetype)initWithModel:(FRStoreModel *)model
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 150 * scale)]) {
        self.model = model;
        [self createStorePriceView];
    }
    return self;
}

- (void)createStorePriceView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel * nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    nameLabel.text = self.model.name;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 80 * scale);
    }];
    
    UILabel * detailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    detailLabel.text = self.model.subtitle;
    [self addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_lessThanOrEqualTo(50 * scale);
    }];
    
    NSString * price = [NSString stringWithFormat:@"￥%.2lf", self.model.price];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = price;
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(30 * scale);
    }];
    
    if (self.model.points > 0) {
        self.pointLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
        self.pointLabel.text = [NSString stringWithFormat:@"+%ld积分", self.model.points];
        [self addSubview:self.pointLabel];
        [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_lessThanOrEqualTo(self.priceLabel);
            make.left.mas_equalTo(self.priceLabel.mas_right).offset(5 * scale);
            make.height.mas_equalTo(30 * scale);
        }];
    }
    
    self.expressLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.expressLabel.text = @"快递：免运费";
    [self addSubview:self.expressLabel];
    [self.expressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.stockLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    [self addSubview:self.stockLabel];
    [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_equalTo(.5f);
    }];
}

- (void)configWithSpecModel:(FRStoreSpecModel *)model
{
    self.specModel = model;
    
    NSString * price = [NSString stringWithFormat:@"￥%.2lf", model.price];
    self.priceLabel.text = price;
    
    NSString * stock = [NSString stringWithFormat:@"库存：%ld件", model.stock];
    self.stockLabel.text = stock;
}

@end

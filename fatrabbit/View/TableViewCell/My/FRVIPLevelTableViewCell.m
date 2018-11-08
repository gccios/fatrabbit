//
//  FRVIPLevelTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRVIPLevelTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRVIPLevelTableViewCell ()

@property (nonatomic, strong) UILabel * levelLabel;
@property (nonatomic, strong) UILabel * pointLabel;
@property (nonatomic, strong) UILabel * discountLabel;

@end

@implementation FRVIPLevelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createVIPLevelLabel];
    }
    return self;
}

- (void)createVIPLevelLabel
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.levelLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(- kMainBoundsWidth/2.f + 50 * scale);
    }];
    
    self.pointLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.pointLabel];
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.discountLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.discountLabel];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(kMainBoundsWidth/2.f - 60 * scale);
    }];
}

- (void)configWithModel:(FRVIPLevelModel *)model
{
    self.levelLabel.text = model.name;
    self.pointLabel.text = model.expense_amount_tip;
    self.discountLabel.text = model.discount_tip;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

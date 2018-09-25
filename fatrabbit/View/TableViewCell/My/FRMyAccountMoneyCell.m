//
//  FRMyAccountMoneyCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/25.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyAccountMoneyCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRMyAccountMoneyCell ()

@property (nonatomic, strong) UILabel * remarkLabel;
@property (nonatomic, strong) UILabel * changeLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation FRMyAccountMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createAccountMoneyCell];
    }
    return self;
}

- (void)configWithMoneyModel:(FRMyAccountMoneyModel *)model
{
    self.remarkLabel.text = model.remark;
    if (model.amount > 0) {
        self.changeLabel.text = [NSString stringWithFormat:@"+%.2lf", model.amount];
    }else{
        self.changeLabel.text = [NSString stringWithFormat:@"%.2lf", model.amount];
    }
    self.timeLabel.text = model.addtime;
}

- (void)configWithPointsModel:(FRMyPointsModel *)model
{
    self.remarkLabel.text = model.remark;
    if (model.points > 0) {
        self.changeLabel.text = [NSString stringWithFormat:@"+%.2lf", model.points];
    }else{
        self.changeLabel.text = [NSString stringWithFormat:@"%.2lf", model.points];
    }
    self.timeLabel.text = model.addtime;
}

- (void)createAccountMoneyCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.remarkLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.remarkLabel.text = @"测试";
    [self.contentView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.changeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.changeLabel.text = @"+90000";
    [self.contentView addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(130 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.timeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    self.timeLabel.text = @"2018-09-31 15:00";
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
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

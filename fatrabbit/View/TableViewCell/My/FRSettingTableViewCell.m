//
//  FRSettingTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRSettingTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRSettingTableViewCell ()

@property (nonatomic, strong) FRSettingModel * model;

@property (nonatomic, strong) UILabel * nameLbel;
@property (nonatomic, strong) UILabel * infoLabel;

@end

@implementation FRSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSettingCell];
    }
    return self;
}

- (void)configWithModel:(FRSettingModel *)model
{
    self.model = model;
    if (!isEmptyString(model.title)) {
        self.nameLbel.text = model.title;
    }
    if (!isEmptyString(model.detail)) {
        self.infoLabel.text = model.detail;
    }
}

- (void)createSettingCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLbel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLbel];
    [self.nameLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.infoLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-50 * scale);
        make.height.mas_equalTo(20 * scale);
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

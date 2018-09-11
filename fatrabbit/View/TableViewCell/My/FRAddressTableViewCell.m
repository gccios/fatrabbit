//
//  FRAddressTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAddressTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRAddressTableViewCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * mobile;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UIButton * editButton;

@property (nonatomic, strong) FRAddressModel * model;

@end

@implementation FRAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createAddressCell];
    }
    return self;
}

- (void)configWithModel:(FRAddressModel *)model
{
    self.model = model;
    self.nameLabel.text = model.consignee;
    self.mobile.text = model.mobile;
    self.addressLabel.text = model.address;
}

- (void)createAddressCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.mobile = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.mobile];
    [self.mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(40 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.addressLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-70 * scale);
    }];
    
    self.editButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0x333333) title:@"编辑"];
    [self.contentView addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-25 * scale);
        make.width.mas_equalTo(30 * scale);
        make.height.mas_equalTo(30 * scale);
    }];
    [self.editButton addTarget:self action:@selector(editButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editButtonDidClicked
{
    if (self.addressEditHandle) {
        self.addressEditHandle();
    }
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

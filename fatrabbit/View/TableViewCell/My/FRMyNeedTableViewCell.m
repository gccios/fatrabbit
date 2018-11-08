//
//  FRMyNeedTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyNeedTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRMyNeedTableViewCell ()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIButton * leftHandleButton;
@property (nonatomic, strong) UIButton * rightHandleButton;

@property (nonatomic, strong) FRNeedModel * model;

@end

@implementation FRMyNeedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFRMyServiceTableViewCell];
    }
    return self;
}

- (void)configWithModel:(FRNeedModel *)model
{
    self.model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.nameLabel.text = model.title;
    self.infoLabel.text = model.remark;
    if (model.amount == 0) {
        self.priceLabel.text = @"面议";
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", model.amount];
    }
    self.numberLabel.text = @"";
}

- (void)deleteSerivice
{
    if (self.deleteHandle) {
        self.deleteHandle(self.model);
    }
}

- (void)editSerivice
{
    if (self.editHandle) {
        self.editHandle(self.model);
    }
}

- (void)createFRMyServiceTableViewCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0Xf5f5f5);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(110 * scale);
        make.height.mas_equalTo(100 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.top.mas_equalTo(self.coverImageView).offset(5 * scale);
        make.width.mas_equalTo(150 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.coverImageView).mas_equalTo(-5* scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.infoLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.infoLabel.numberOfLines = 3;
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(self.priceLabel);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:KThemeColor alignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15 * scale);
        make.center.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.rightHandleButton = [FRCreateViewTool createButtonWithFrame: CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"修改"];
    self.rightHandleButton.backgroundColor = UIColorFromRGB(0xf6d365);
    [self.contentView addSubview:self.rightHandleButton];
    [self.rightHandleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15 * scale);
        make.centerY.mas_equalTo(self.priceLabel);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    [FRCreateViewTool cornerView:self.rightHandleButton radius:5 * scale];
    [self.rightHandleButton addTarget:self action:@selector(editSerivice) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftHandleButton = [FRCreateViewTool createButtonWithFrame: CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0x999999) title:@"删除"];
    [self.contentView addSubview:self.leftHandleButton];
    [self.leftHandleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightHandleButton.mas_left).offset(-10 * scale);
        make.centerY.mas_equalTo(self.priceLabel);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    [FRCreateViewTool cornerView:self.leftHandleButton radius:5 * scale];
    self.leftHandleButton.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.leftHandleButton.layer.borderWidth = .5f;
    [self.leftHandleButton addTarget:self action:@selector(deleteSerivice) forControlEvents:UIControlEventTouchUpInside];
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

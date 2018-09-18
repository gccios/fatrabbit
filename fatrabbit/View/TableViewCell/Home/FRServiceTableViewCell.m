//
//  FRServiceTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRServiceTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRServiceTableViewCell ()

@property (nonatomic, strong) FRNeedModel * model;

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * browseLabel;

@end

@implementation FRServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFRSeriveceCell];
    }
    return self;
}

- (void)configWithModel:(FRNeedModel *)model
{
    self.model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.nameLabel.text = model.title;
    self.detailLabel.text = model.remark;
    self.browseLabel.text = model.pvtip;
    self.timeLabel.text = model.timetip;
}

- (void)createFRSeriveceCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0Xf5f5f5);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.contentView addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(-5 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    baseView.layer.cornerRadius = 10 * scale;
    baseView.layer.shadowColor = UIColorFromRGB(0x333333).CGColor;
    baseView.layer.shadowOpacity = .2f;
    baseView.layer.shadowRadius = 4 * scale;
    baseView.layer.shadowOffset = CGSizeMake(0, 2 * scale);
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.clipsToBounds = YES;
    [baseView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.width.height.mas_equalTo(90 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.top.mas_equalTo(10 * scale);
        make.width.mas_equalTo(150 * scale);
    }];
    
    self.timeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    [baseView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.right.mas_equalTo(-10 * scale);
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    self.detailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    self.detailLabel.numberOfLines = 3;
    [baseView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.timeLabel);
    }];
    
    self.browseLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [baseView addSubview:self.browseLabel];
    [self.browseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10 * scale);
        make.left.mas_equalTo(self.detailLabel);
        make.right.mas_equalTo(self.detailLabel);
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

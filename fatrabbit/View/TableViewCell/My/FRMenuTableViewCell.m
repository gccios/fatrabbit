//
//  FRMenuTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMenuTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRMenuTableViewCell ()

@property (nonatomic, strong) UIImageView * menuImageView;
@property (nonatomic, strong) UILabel * menuLabel;
@property (nonatomic, strong) UILabel * infoLabel;

@property (nonatomic, strong) MyMenuModel * model;

@end

@implementation FRMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createMenuTableViewCell];
    }
    return self;
}

- (void)configWithModel:(MyMenuModel *)model
{
    self.model = model;
    self.menuLabel.text = model.title;
    [self.menuImageView setImage:[UIImage imageNamed:model.imageName]];
    self.infoLabel.text = model.detail;
}

- (void)createMenuTableViewCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.menuImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleToFill image:[UIImage new]];
    [self.contentView addSubview:self.menuImageView];
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(25 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    
    self.menuLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.menuLabel];
    [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.menuImageView.mas_right).offset(20 * scale);
        make.right.mas_equalTo(-40 * scale);
    }];
    
    self.infoLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.menuLabel);
        make.right.mas_equalTo(-40 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIImageView * moreImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
    [self.contentView addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(7 * scale);
        make.height.mas_equalTo(13 * scale);
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

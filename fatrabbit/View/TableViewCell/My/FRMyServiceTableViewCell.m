//
//  FRMyServiceTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyServiceTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRMyServiceTableViewCell ()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * levelLabel;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIButton * leftHandleButton;
@property (nonatomic, strong) UIButton * rightHandleButton;

@end

@implementation FRMyServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFRMyServiceTableViewCell];
    }
    return self;
}

- (void)createFRMyServiceTableViewCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0Xf5f5f5);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(110 * scale);
        make.height.mas_equalTo(110 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"测试标题测试标题";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.top.mas_equalTo(self.coverImageView).offset(5 * scale);
        make.width.mas_equalTo(150 * scale);
    }];
    
    UILabel * totalTitleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    totalTitleLabel.text = @"￥";
    [self.contentView addSubview:totalTitleLabel];
    [totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.coverImageView).mas_equalTo(-5* scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = @"测试金额";
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalTitleLabel.mas_right);
        make.centerY.height.mas_equalTo(totalTitleLabel);
    }];
    
    self.infoLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.infoLabel.numberOfLines = 3;
    self.infoLabel.text = @"测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情测试详情";
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(totalTitleLabel);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.levelLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:KThemeColor alignment:NSTextAlignmentRight];
    self.levelLabel.text = @"5.0";
    [self.contentView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

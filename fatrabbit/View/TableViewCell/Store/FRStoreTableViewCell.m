//
//  FRStoreTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRStoreTableViewCell ()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * commentLabel;
@property (nonatomic, strong) UILabel * dealLabel;
@property (nonatomic, strong) UIButton * buyButton;

@end

@implementation FRStoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFtoreTableViewCell];
    }
    return self;
}

- (void)createFtoreTableViewCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(120 * scale);
        make.height.mas_equalTo(80 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"测试标题测试标题测试标题";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView).mas_equalTo(5 * scale);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    UILabel * price = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    price.text = @"￥";
    [self.contentView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.coverImageView);
        make.left.mas_equalTo(self.coverImageView.mas_right).mas_offset(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = @"测试金额";
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(price);
        make.left.mas_equalTo(price.mas_right);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.commentLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.commentLabel.text = @"测试评论数";
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.coverImageView.mas_bottom).offset(-5 * scale);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.dealLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.dealLabel.text = @"测试成交数10单";
    [self.contentView addSubview:self.dealLabel];
    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.commentLabel);
        make.left.mas_equalTo(self.commentLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.buyButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@""];
    self.buyButton.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.dealLabel);
        make.width.mas_equalTo(25 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-20 * scale);
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

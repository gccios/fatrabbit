//
//  FRStoreCartOrderDetailCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreCartOrderDetailCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRStoreCartOrderDetailCell ()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLable;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * priceLabel;

@end

@implementation FRStoreCartOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createOrderDetailCell];
    }
    return self;
}

- (void)createOrderDetailCell
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@""]];
    self.coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(110 * scale);
    }];
    
    self.nameLable = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(12 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_top).offset(5 * scale);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0xE52424) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.coverImageView);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(9 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.coverImageView.mas_bottom).offset(-5 * scale);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
}

- (void)confiWithModel:(FRStoreCartModel *)model
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.nameLable.text = [NSString stringWithFormat:@"%@（%@）", model.pname, model.sname];
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld", model.num];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", model.price];
    if (model.single > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"%.2lf 积分", model.single];
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

//
//  FRUserMenuLogoCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserMenuLogoCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import "UserManager.h"
#import <UIImageView+WebCache.h>

@interface FRUserMenuLogoCell ()

@property (nonatomic, strong) FRUserMenuModel * model;

@property (nonatomic, strong) UILabel * nameLbel;
@property (nonatomic, strong) UIImageView * logoImageView;

@end

@implementation FRUserMenuLogoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUserMenuLogoCell];
    }
    return self;
}

- (void)configWithModel:(FRUserMenuModel *)model
{
    self.model = model;
    
    self.nameLbel.text = model.title;
    if (model.image) {
        [self.logoImageView setImage:model.image];
    }
}

- (void)createUserMenuLogoCell
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
    
    self.logoImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:nil];
    self.logoImageView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    if (!isEmptyString([UserManager shareManager].avatar)) {
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager shareManager].avatar]];
    }
    [self.contentView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-50 * scale);
        make.width.height.mas_equalTo(50 * scale);
    }];
    [FRCreateViewTool cornerView:self.logoImageView radius:25 * scale];
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

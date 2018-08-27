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
}

- (void)createMenuTableViewCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.menuImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleToFill image:[UIImage new]];
    self.menuImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.menuImageView];
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(30 * scale);
        make.height.mas_equalTo(30 * scale);
    }];
    
    self.menuLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.menuLabel];
    [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.menuImageView.mas_right).offset(20 * scale);
        make.right.mas_equalTo(-40 * scale);
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

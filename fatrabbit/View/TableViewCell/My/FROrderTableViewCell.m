//
//  FROrderTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FROrderTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FROrderTableViewCell ()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * totalLabel;

@property (nonatomic, strong) UIButton * leftHandleButton;
@property (nonatomic, strong) UIButton * rightHandleButton;

@end

@implementation FROrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFROrderTableViewCell];
    }
    return self;
}

- (void)createFROrderTableViewCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0XEFEFF4);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(120 * scale);
        make.height.mas_equalTo(90 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"测试标题测试标题";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.top.mas_equalTo(self.coverImageView).offset(5 * scale);
        make.width.mas_equalTo(150 * scale);
    }];
    
    UILabel * totalTitleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    totalTitleLabel.text = @"合计：";
    [self.contentView addSubview:totalTitleLabel];
    [totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.coverImageView).mas_equalTo(-5* scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.totalLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.totalLabel.text = @"测试金额";
    [self.contentView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.totalLabel.mas_right).offset(5 * scale);
        make.centerY.height.mas_equalTo(totalTitleLabel);
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

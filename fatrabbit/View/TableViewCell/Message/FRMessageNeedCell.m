//
//  FRMessageNeedCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMessageNeedCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRMessageNeedCell ()

@property (nonatomic, strong) UIImageView * needImageView;
@property (nonatomic, strong) UILabel * needLabel;

@end

@implementation FRMessageNeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createMessageNeedCell];
    }
    return self;
}

- (void)configWithModel:(FRMessageModel *)model
{
    [self.needImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.needLabel.text = model.tip;
}

- (void)createMessageNeedCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.needImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.needImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.needImageView];
    [self.needImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100 * scale);
        make.height.mas_equalTo(75 * scale);
    }];
    
    self.needLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.needLabel.numberOfLines = 3;
    [self.contentView addSubview:self.needLabel];
    [self.needLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.needImageView.mas_right).offset(10 * scale);
        make.right.mas_equalTo(-40 * scale);
    }];
    
    UIImageView * moreImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
    [self.contentView addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
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

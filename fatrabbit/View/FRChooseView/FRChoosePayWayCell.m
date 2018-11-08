//
//  FRChoosePayWayCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRChoosePayWayCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRChoosePayWayCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * chooseImageView;

@end

@implementation FRChoosePayWayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFRChooseCell];
    }
    return self;
}

- (void)configWithModel:(FRPayWayModel *)model withChoose:(BOOL)chooseEnable
{
    self.nameLabel.text = model.title;
    if (chooseEnable) {
        [self.chooseImageView setImage:[UIImage imageNamed:@"choose"]];
    }else{
        [self.chooseImageView setImage:[UIImage imageNamed:@"chooseno"]];
    }
    if (model.type == FRPayWayType_FenQi) {
        self.nameLabel.textColor = UIColorFromRGB(0x999999);
    }else{
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
    }
}

- (void)createFRChooseCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 70 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.contentView addSubview:self.nameLabel];
    
    self.chooseImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"chooseno"]];
    [self.contentView addSubview:self.chooseImageView];
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15 * scale);
        make.width.height.mas_equalTo(20 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
        make.right.mas_equalTo(-15 * scale);
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

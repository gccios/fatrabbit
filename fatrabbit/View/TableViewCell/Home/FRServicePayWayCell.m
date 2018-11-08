//
//  FRServicePayWayCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRServicePayWayCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRServicePayWayCell ()

@property (nonatomic, strong) UIImageView * chooseImageView;
@property (nonatomic, strong) UILabel * infoLabel;

@end

@implementation FRServicePayWayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createPayWayCell];
    }
    return self;
}

- (void)configWithModel:(FRServicePayWayModel *)model
{
    self.infoLabel.text = model.info;
}

- (void)configChoose:(BOOL)choose
{
    if (choose) {
        [self.chooseImageView setImage:[UIImage imageNamed:@"choose"]];
    }else{
        [self.chooseImageView setImage:[UIImage imageNamed:@"chooseno"]];
    }
}

- (void)createPayWayCell
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.chooseImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"chooseno"]];
    [self.contentView addSubview:self.chooseImageView];
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30 * scale);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(22 * scale);
    }];
    
    self.infoLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    self.infoLabel.numberOfLines = 0;
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chooseImageView.mas_right).offset(15 * scale);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-50 * scale);
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

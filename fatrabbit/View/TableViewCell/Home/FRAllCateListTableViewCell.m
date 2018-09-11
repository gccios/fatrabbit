//
//  FRAllCateListTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAllCateListTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRAllCateListTableViewCell ()

@property (nonatomic, strong) FRCateModel * model;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * infoLabel;

@end

@implementation FRAllCateListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFRAllCateCell];
    }
    return self;
}

- (void)configWithModel:(FRCateModel *)model
{
    self.model = model;
    self.nameLabel.text = model.name;
    self.infoLabel.text = model.intro;
}

- (void)createFRAllCateCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(25);
    }];
    
    self.infoLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-30);
        make.width.mas_equalTo(150);
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

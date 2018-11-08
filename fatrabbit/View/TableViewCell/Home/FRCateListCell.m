//
//  FRCateListCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCateListCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRCateListCell ()

@property (nonatomic, strong) FRCateModel * model;

@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation FRCateListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFRCateCell];
    }
    return self;
}

- (void)configWithModel:(FRCateModel *)model
{
    self.model = model;
    self.nameLabel.text = model.name;
}

- (void)configWithTextColor:(UIColor *)color
{
    [self.nameLabel setTextColor:color];
}

- (void)configWithTextFont:(UIFont *)font
{
    [self.nameLabel setFont:font];
}

- (void)createFRCateCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(14) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the view for the selected state
}

@end

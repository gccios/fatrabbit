//
//  FRCateChildCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCateChildCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRCateChildCell ()

@property (nonatomic, strong) FRCateModel * model;

@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation FRCateChildCell

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

- (void)createFRCateCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
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

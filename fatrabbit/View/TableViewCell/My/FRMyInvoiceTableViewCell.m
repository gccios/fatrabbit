//
//  FRMyInvoiceTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyInvoiceTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRMyInvoiceTableViewCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation FRMyInvoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createInvoiceCell];
    }
    return self;
}

- (void)editDidClicked
{
    if (self.invoiceEditHandle) {
        self.invoiceEditHandle();
    }
}

- (void)deleteDidClicked
{
    if (self.invoiceDeleteHandle) {
        self.invoiceDeleteHandle();
    }
}

- (void)createInvoiceCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"测试发票公司名称";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(17 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.numberLabel.text = @"0000000000000";
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.left.mas_equalTo(17 * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(12 * scale);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    UIButton * editButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xFF5858) title:@"修改"];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(70 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    [FRCreateViewTool cornerView:editButton radius:4 * scale];
    editButton.layer.borderColor = UIColorFromRGB(0xFF5858).CGColor;
    editButton.layer.borderWidth = .5f;
    [editButton addTarget:self action:@selector(editDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * deleteButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0x999999) title:@"删除"];
    [self.contentView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.right.mas_equalTo(editButton.mas_left).offset(-15 * scale);
        make.width.mas_equalTo(70 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    [FRCreateViewTool cornerView:deleteButton radius:4 * scale];
    deleteButton.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    deleteButton.layer.borderWidth = .5f;
    [deleteButton addTarget:self action:@selector(deleteDidClicked) forControlEvents:UIControlEventTouchUpInside];
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

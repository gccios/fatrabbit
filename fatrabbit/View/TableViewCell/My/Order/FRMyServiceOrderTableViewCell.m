//
//  FRMyServiceOrderTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyServiceOrderTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface FRMyServiceOrderTableViewCell ()

@property (nonatomic, strong) FRMyServiceOrderModel * model;

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * totalLabel;

@property (nonatomic, strong) UIButton * leftHandleButton;
@property (nonatomic, strong) UIButton * rightHandleButton;

@end

@implementation FRMyServiceOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFROrderTableViewCell];
    }
    return self;
}

- (void)configWithModel:(FRMyServiceOrderModel *)model
{
    self.model = model;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.nameLabel.text = model.title;
    self.totalLabel.text = [NSString stringWithFormat:@"%.2lf", model.amount];
    self.numberLabel.text = [NSString stringWithFormat:@"数量：%ld", model.num];
    
    if (model.paytype == 2) {
        if (model.paystatus == 1) {
            if (model.rest_paystatus == 0) {
                self.statusLabel.text = @"待支付";
                [self.rightHandleButton setTitle:@"付款" forState:UIControlStateNormal];
                [self.leftHandleButton setTitle:@"取消" forState:UIControlStateNormal];
            }
        }else{
            self.statusLabel.text = @"待支付";
            [self.rightHandleButton setTitle:@"付款" forState:UIControlStateNormal];
            [self.leftHandleButton setTitle:@"取消" forState:UIControlStateNormal];
        }
        return;
    }
    
    switch (model.type) {
        case 1:
        {
            self.statusLabel.text = @"待付款";
            [self.rightHandleButton setTitle:@"付款" forState:UIControlStateNormal];
            [self.leftHandleButton setTitle:@"取消" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            self.statusLabel.text = @"待收货";
            [self.rightHandleButton setTitle:@"查看订单" forState:UIControlStateNormal];
            [self.leftHandleButton setTitle:@"联系Ta" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.statusLabel.text = @"待评价";
            [self.rightHandleButton setTitle:@"评价" forState:UIControlStateNormal];
            [self.leftHandleButton setTitle:@"联系Ta" forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            self.statusLabel.text = @"已完成";
            [self.rightHandleButton setTitle:@"查看订单" forState:UIControlStateNormal];
            [self.leftHandleButton setTitle:@"联系Ta" forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            self.statusLabel.text = @"已取消";
            [self.rightHandleButton setTitle:@"查看订单" forState:UIControlStateNormal];
            [self.leftHandleButton setTitle:@"联系Ta" forState:UIControlStateNormal];
        }
            break;
            
        default:
        {
            self.statusLabel.text = @"已完成";
            [self.rightHandleButton setTitle:@"查看订单" forState:UIControlStateNormal];
            [self.leftHandleButton setTitle:@"联系Ta" forState:UIControlStateNormal];
        }
            break;
    }
}

- (void)createFROrderTableViewCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0Xf5f5f5);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(110 * scale);
        make.height.mas_equalTo(90 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10 * scale);
        make.top.mas_equalTo(self.coverImageView).offset(5 * scale);
        make.width.mas_equalTo(150 * scale);
    }];
    
    UILabel * totalTitleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    totalTitleLabel.text = @"合计：";
    [self.contentView addSubview:totalTitleLabel];
    [totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.coverImageView).mas_equalTo(-5* scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.totalLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalTitleLabel.mas_right);
        make.centerY.height.mas_equalTo(totalTitleLabel);
    }];
    
    self.numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalTitleLabel);
        make.bottom.mas_equalTo(self.totalLabel.mas_top).offset(-5 * scale);
        make.height.mas_equalTo(16 * scale);
    }];
    
    self.statusLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15 * scale);
        make.center.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.rightHandleButton = [FRCreateViewTool createButtonWithFrame: CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"再次购买"];
    self.rightHandleButton.backgroundColor = UIColorFromRGB(0xf6d365);
    [self.contentView addSubview:self.rightHandleButton];
    [self.rightHandleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15 * scale);
        make.bottom.mas_equalTo(-10 * scale);
        make.width.mas_equalTo(60 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    [FRCreateViewTool cornerView:self.rightHandleButton radius:5 * scale];
    
    self.leftHandleButton = [FRCreateViewTool createButtonWithFrame: CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0x999999) title:@"联系Ta"];
    [self.contentView addSubview:self.leftHandleButton];
    [self.leftHandleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightHandleButton.mas_left).offset(-10 * scale);
        make.centerY.mas_equalTo(self.rightHandleButton);
        make.width.mas_equalTo(60 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    [FRCreateViewTool cornerView:self.leftHandleButton radius:5 * scale];
    self.leftHandleButton.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.leftHandleButton.layer.borderWidth = .5f;
    
    [self.leftHandleButton addTarget:self action:@selector(leftButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.rightHandleButton addTarget:self action:@selector(rightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftButtonDidClicked
{
    if (self.leftHandle) {
        self.leftHandle(self.model);
    }
}

- (void)rightButtonDidClicked
{
    if (self.rightHandle) {
        self.rightHandle(self.model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

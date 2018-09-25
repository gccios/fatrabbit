//
//  FRStoreCartTableViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreCartTableViewCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UserManager.h"
#import "FRStoreCartRequest.h"
#import "MBProgressHUD+FRHUD.h"

@interface FRStoreCartTableViewCell ()

@property (nonatomic, strong) FRStoreCartModel * model;

@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIButton * numberButton;
@property (nonatomic, strong) UIButton * addButton;
@property (nonatomic, strong) UIButton * deleteButton;

@end

@implementation FRStoreCartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createStoreCartCell];
    }
    return self;
}

- (void)addButtonDidClicked
{
    if (self.model.num == self.model.stock) {
        [MBProgressHUD showTextHUDWithText:@"商品库存不足"];
        return;
    }
    
    self.model.num++;
    [self reloadGoodsModel];
    if (self.addButton) {
        self.addCartHandle(self.model);
    }
}

- (void)deleteButtonDidClicked
{
    if (self.model.num == self.model.min_buy_num) {
        [MBProgressHUD showTextHUDWithText:[NSString stringWithFormat:@"该商品最少购买%ld件", self.model.min_buy_num]];
        return;
    }
    
    if (self.model.num > 1) {
        self.model.num--;
        [self reloadGoodsModel];
        if (self.deleteCartHandle) {
            self.deleteCartHandle(self.model);
        }
    }
}

- (void)selectButtonDidClicked
{
    self.model.isSelected = !self.model.isSelected;
    [self reloadGoodsModel];
    if (self.chooseCartHandle) {
        self.chooseCartHandle(self.model);
    }
}

- (void)reloadGoodsModel
{
    self.model.amount = self.model.num * self.model.price;
    
    NSString * numberStr = [NSString stringWithFormat:@"%ld", self.model.num];
    NSString * priceStr = [NSString stringWithFormat:@"%.2lf", self.model.amount];
    [self.numberButton setTitle:numberStr forState:UIControlStateNormal];
    self.priceLabel.text = priceStr;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.model.cover]];
    self.nameLabel.text = self.model.pname;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2lf", self.model.price];
    if (self.model.isSelected) {
        [self.selectButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }else{
        [self.selectButton setImage:[UIImage imageNamed:@"chooseno"] forState:UIControlStateNormal];
    }
}

- (void)configWithGoodsModel:(FRStoreCartModel *)model
{
    self.model = model;
    [self reloadGoodsModel];
}

- (void)createStoreCartCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:[UIColor whiteColor] title:@""];
    [self.selectButton setImage:[UIImage imageNamed:@"chooseno"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(5 * scale);
        make.bottom.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(30 * scale);
    }];
    [self.selectButton addTarget:self action:@selector(selectButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    [self.contentView addSubview:self.coverImageView];
    self.coverImageView.clipsToBounds = YES;
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(-15 * scale);
        make.left.mas_equalTo(self.selectButton.mas_right).offset(10 * scale);
        make.width.mas_equalTo(100 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView).mas_equalTo(5 * scale);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * price = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    price.text = @"￥";
    [self.contentView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.coverImageView).mas_equalTo(-10 * scale);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(price);
        make.left.mas_equalTo(price.mas_right);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.numberButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0x333333) title:@"1"];
    [self.contentView addSubview:self.numberButton];
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(price);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.deleteButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:[UIColor whiteColor] title:@""];
    [self.deleteButton setImage:[UIImage imageNamed:@"cartDelete"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberButton.mas_right);
        make.centerY.mas_equalTo(self.numberButton);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self.deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:[UIColor whiteColor] title:@""];
    [self.addButton setImage:[UIImage imageNamed:@"cartAdd"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.numberButton.mas_left);
        make.centerY.mas_equalTo(self.numberButton);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self.addButton addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
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

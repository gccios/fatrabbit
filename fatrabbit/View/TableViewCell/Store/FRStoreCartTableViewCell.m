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

@interface FRStoreCartTableViewCell ()

@property (nonatomic, strong) FRStoreModel * model;

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
    self.model.num++;
    [self reloadGoodsModel];
}

- (void)deleteButtonDidClicked
{
    if (self.model.num > 1) {
        self.model.num--;
        [self reloadGoodsModel];
    }
}

- (void)reloadGoodsModel
{
    CGFloat price = self.model.num * self.model.price;
    
    NSString * numberStr = [NSString stringWithFormat:@"%ld", self.model.num];
    NSString * priceStr = [NSString stringWithFormat:@"%.2lf", price];
    [self.numberButton setTitle:numberStr forState:UIControlStateNormal];
    self.priceLabel.text = priceStr;
}

- (void)configWithGoodsModel:(FRStoreModel *)model
{
    self.model = model;
    [self reloadGoodsModel];
}

- (void)createStoreCartCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:[UIColor whiteColor] title:@""];
    self.selectButton.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(5 * scale);
        make.bottom.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(30 * scale);
    }];
    
    self.coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    self.coverImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(-15 * scale);
        make.left.mas_equalTo(self.selectButton.mas_right).offset(5 * scale);
        make.width.mas_equalTo(100 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"测试标题测试标题";
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
    self.priceLabel.text = @"测试金额";
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
    self.deleteButton.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberButton.mas_right);
        make.centerY.mas_equalTo(self.numberButton);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self.deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:[UIColor whiteColor] title:@""];
    self.addButton.backgroundColor = [UIColor greenColor];
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

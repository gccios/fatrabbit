//
//  FRStorePayMenuCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/18.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStorePayMenuCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import "UserManager.h"

@interface FRStorePayMenuCell ()

@property (nonatomic, strong) FRStorePayMenuModel * model;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UIImageView * moreImageView;
@property (nonatomic, strong) UIImageView * chooseImageView;

@end

@implementation FRStorePayMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createStorePayMenuCell];
    }
    return self;
}

- (void)confiWithModel:(FRStorePayMenuModel *)model
{
    self.model = model;
    self.nameLabel.text = model.title;
    self.infoLabel.text = model.detail;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (model.type == FRStorePayMenuType_Points || model.type == FRStorePayMenuType_Discount) {
        self.moreImageView.hidden = YES;
//        self.chooseImageView.hidden = NO;
        
//        if (model.isChoose) {
//            [self.chooseImageView setImage:[UIImage imageNamed:@"choose"]];
//        }else{
//            [self.chooseImageView setImage:[UIImage imageNamed:@"chooseno"]];
//        }
        self.infoLabel.textColor = KThemeColor;
        [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15 * scale);
        }];
        
        if (model.type == FRStorePayMenuType_Discount) {
            self.infoLabel.text = [NSString stringWithFormat:@"VIP折扣：%@", [UserManager shareManager].vip_discount_tip];
        }
        
    }else{
        self.moreImageView.hidden = NO;
        self.chooseImageView.hidden = YES;
        self.infoLabel.textColor = UIColorFromRGB(0x999999);
    }
}

- (void)createStorePayMenuCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(25);
    }];
    
    self.infoLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(kMainBoundsWidth - 150);
        make.right.mas_equalTo(-50);
    }];
    
    self.moreImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
    [self.contentView addSubview:self.moreImageView];
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
    }];
    
    self.chooseImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"chooseno"]];
    [self.contentView addSubview:self.chooseImageView];
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(20);
    }];
    self.chooseImageView.hidden = YES;
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

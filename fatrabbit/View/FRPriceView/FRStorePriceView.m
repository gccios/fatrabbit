//
//  FRStorePriceView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStorePriceView.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import "FRStoreTagCollectionViewCell.h"
#import "UserManager.h"

@interface FRStorePriceView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) FRStoreModel * model;
@property (nonatomic, strong) FRStoreSpecModel * specModel;

@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * pointLabel;
@property (nonatomic, strong) UILabel * expressLabel;
@property (nonatomic, strong) UILabel * stockLabel;

@property (nonatomic, strong) NSMutableArray * tagSource;
@property (nonatomic, strong) UICollectionView * tagCollectionView;

@property (nonatomic, strong) UIView * regionView;
@property (nonatomic, strong) UILabel * firstPriceLabel;
@property (nonatomic, strong) UILabel * firstRegionLabel;
@property (nonatomic, strong) UILabel * secondPriceLabel;
@property (nonatomic, strong) UILabel * secondRegionLabel;
@property (nonatomic, strong) UILabel * thirdPriceLabel;
@property (nonatomic, strong) UILabel * thirdRegionLabel;

@end

@implementation FRStorePriceView

- (instancetype)initWithModel:(FRStoreModel *)model
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 190 * scale)]) {
        self.model = model;
        
        self.tagSource = [[NSMutableArray alloc] init];
        [self.tagSource addObject:[[FRStoreTagModel alloc] initWithType:FRStoreTagType_VIP]];
        [self.tagSource addObject:[[FRStoreTagModel alloc] initWithType:FRStoreTagType_PiFa]];
        [self.tagSource addObject:[[FRStoreTagModel alloc] initWithType:FRStoreTagType_Points]];
        [self.tagSource addObject:[[FRStoreTagModel alloc] initWithType:FRStoreTagType_GivePoints]];
        [self.tagSource addObject:[[FRStoreTagModel alloc] initWithType:FRStoreTagType_FenQi]];
        
        [self createStorePriceView];
    }
    return self;
}

- (void)configWithSpecModel:(FRStoreSpecModel *)model
{
    self.specModel = model;
    
    NSString * price = [NSString stringWithFormat:@"￥%.2lf", model.price];
    
    if (model.price_range.count > 0) {
        self.priceLabel.textColor = UIColorFromRGB(0x999999);
        price = [NSString stringWithFormat:@"原价：￥%.2lf", model.price];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorFromRGB(0x333333);
        [self.priceLabel addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }else{
        self.priceLabel.textColor = KPriceColor;
        [self.priceLabel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (self.model.is_points) {
        price = [NSString stringWithFormat:@"%.2lf 积分", model.points];
    }
    self.priceLabel.text = price;
    
    NSString * stock = [NSString stringWithFormat:@"剩余：%ld件", model.stock];
    self.stockLabel.text = stock;
    
    [self createRegionView];
}

- (void)createStorePriceView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel * nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    nameLabel.numberOfLines = 0;
    nameLabel.text = self.model.name;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 80 * scale);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kMainBoundsWidth / 8.f, 27 * scale);
    layout.minimumLineSpacing = 5 * scale;
    layout.minimumInteritemSpacing = 5 * scale;
    
    self.tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.tagCollectionView registerClass:[FRStoreTagCollectionViewCell class] forCellWithReuseIdentifier:@"FRStoreTagCollectionViewCell"];
    self.tagCollectionView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    self.tagCollectionView.scrollEnabled = NO;
    self.tagCollectionView.contentInset = UIEdgeInsetsMake(0, 10 * scale, 0, 0);
    [self addSubview:self.tagCollectionView];
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(5 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30*scale);
    }];
    
    UILabel * detailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    detailLabel.numberOfLines = 0;
    detailLabel.text = self.model.subtitle;
    [self addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagCollectionView.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_lessThanOrEqualTo(50 * scale);
    }];
    
    if (!isEmptyString(self.model.subtitle)) {
        CGFloat titleHeight = [self.model.name boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 80 * scale, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(15 * scale)} context:nil].size.height;
        CGFloat height = [self.model.subtitle boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, 50 * scale) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(10 * scale)} context:nil].size.height;
        self.frame = CGRectMake(0, 0, kMainBoundsWidth, 190 * scale + height + titleHeight);
    }
    
    self.regionView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.regionView];
    [self.regionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailLabel.mas_bottom).offset(0 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0 * scale);
    }];
    
    UILabel * priceTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    priceTipLabel.text = @"";
    [self addSubview:priceTipLabel];
    [priceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.regionView.mas_bottom).offset(0 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(30 * scale);
    }];
    
    NSString * price = [NSString stringWithFormat:@"￥%.2lf", self.model.price];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KPriceColor alignment:NSTextAlignmentLeft];
    self.priceLabel.text = price;
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceTipLabel);
        make.left.mas_equalTo(priceTipLabel.mas_right);
        make.height.mas_equalTo(30 * scale);
    }];
    
    if (self.model.points > 0) {
        self.pointLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
        self.pointLabel.text = [NSString stringWithFormat:@"+%.2lf积分", self.model.points];
        [self addSubview:self.pointLabel];
        [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_lessThanOrEqualTo(self.priceLabel);
            make.left.mas_equalTo(self.priceLabel.mas_right).offset(5 * scale);
            make.height.mas_equalTo(30 * scale);
        }];
    }
    
    if (!isEmptyString([UserManager shareManager].vip_discount_tip)) {
        UILabel * discountLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:KPriceColor alignment:NSTextAlignmentRight];
        
        if ([UserManager shareManager].vip_discount == 1) {
            discountLabel.text = [NSString stringWithFormat:@"%@  %@", [UserManager shareManager].vip_name, [UserManager shareManager].vip_discount_tip];
        }else{
            discountLabel.text = [NSString stringWithFormat:@"%@  %@(下单享受优惠)", [UserManager shareManager].vip_name, [UserManager shareManager].vip_discount_tip];
        }
        
        [self addSubview:discountLabel];
        [discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15 * scale);
            make.centerY.mas_equalTo(self.priceLabel);
            make.height.mas_equalTo(20 * scale);
        }];
    }
    
    self.expressLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.expressLabel.text = @"快递：免运费";
    [self addSubview:self.expressLabel];
    [self.expressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.stockLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    [self addSubview:self.stockLabel];
    [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_equalTo(.5f);
    }];
}

- (void)createRegionView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    [self.regionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.specModel) {
        [self.regionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        return;
    }else{
        if (self.specModel.price_range && self.specModel.price_range.count > 0) {
            [self.regionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50 * scale);
            }];
        }else{
            [self.regionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            return;
        }
    }
    
    CGFloat width = (kMainBoundsWidth - 30 * scale) / 3.f;
    
    self.firstPriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KPriceColor alignment:NSTextAlignmentCenter];
    [self.regionView addSubview:self.firstPriceLabel];
    [self.firstPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.mas_equalTo(5 * scale);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.firstRegionLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentCenter];
    [self.regionView addSubview:self.firstRegionLabel];
    [self.firstRegionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.mas_equalTo(self.firstPriceLabel.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.secondPriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KPriceColor alignment:NSTextAlignmentCenter];
    [self.regionView addSubview:self.secondPriceLabel];
    [self.secondPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstPriceLabel.mas_right);
        make.top.mas_equalTo(5 * scale);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.secondRegionLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentCenter];
    [self.regionView addSubview:self.secondRegionLabel];
    [self.secondRegionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstRegionLabel.mas_right);
        make.top.mas_equalTo(self.secondPriceLabel.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.thirdPriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KPriceColor alignment:NSTextAlignmentCenter];
    [self.regionView addSubview:self.thirdPriceLabel];
    [self.thirdPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondPriceLabel.mas_right);
        make.top.mas_equalTo(5 * scale);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.thirdRegionLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentCenter];
    [self.regionView addSubview:self.thirdRegionLabel];
    [self.thirdRegionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondRegionLabel.mas_right);
        make.top.mas_equalTo(self.secondPriceLabel.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(15 * scale);
    }];
    
    for (NSInteger i = 0; i < self.specModel.price_range.count; i++) {
        NSDictionary * dict = [self.specModel.price_range objectAtIndex:i];
        if (KIsDictionary(dict)) {
            NSInteger min = [[dict objectForKey:@"min"] integerValue];
            NSInteger max = [[dict objectForKey:@"max"] integerValue];
            CGFloat price = [[dict objectForKey:@"price"] floatValue];
            if (max > 0) {
                if (i == 0) {
                    self.firstPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", price];
                    self.firstRegionLabel.text = [NSString stringWithFormat:@"%ld~%ld件", min, max];
                }else if (i == 1) {
                    self.secondPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", price];
                    self.secondRegionLabel.text = [NSString stringWithFormat:@"%ld~%ld件", min, max];
                }else if (i == 2) {
                    self.thirdPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", price];
                    self.thirdRegionLabel.text = [NSString stringWithFormat:@"%ld~%ld件", min, max];
                }
            }else if (max < 0) {
                if (i == 0) {
                    self.firstPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", price];
                    self.firstRegionLabel.text = [NSString stringWithFormat:@"≥%ld件", min];
                }else if (i == 1) {
                    self.secondPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", price];
                    self.secondRegionLabel.text = [NSString stringWithFormat:@"≥%ld件", min];
                }else if (i == 2) {
                    self.thirdPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", price];
                    self.thirdRegionLabel.text = [NSString stringWithFormat:@"≥%ld件", min];
                }
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRStoreTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRStoreTagCollectionViewCell" forIndexPath:indexPath];
    
    FRStoreTagModel * model = [self.tagSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    if (self.model.is_points) {
        if (model.type == FRStoreTagType_Points) {
            [cell configWithHighLight:YES];
        }else{
            [cell configWithHighLight:NO];
        }
    }else{
        if (model.type == FRStoreTagType_VIP || model.type == FRStoreTagType_GivePoints) {
            [cell configWithHighLight:YES];
        }else if(model.type == FRStoreTagType_PiFa) {
            
            if (self.specModel.price_range && self.specModel.price_range.count > 0) {
                [cell configWithHighLight:YES];
            }else{
                [cell configWithHighLight:NO];
            }
            
        }else{
            [cell configWithHighLight:NO];
        }
    }
    
    return cell;
}

@end

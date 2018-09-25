//
//  FRStoreCartModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>

@interface FRStoreCartModel : NSObject

@property (nonatomic, assign) NSInteger cid;//购物车id
@property (nonatomic, assign) NSInteger sid;//商品规格id
@property (nonatomic, assign) NSInteger pid;//商品id
@property (nonatomic, assign) NSInteger num;//购买数量
@property (nonatomic, assign) CGFloat price;//单价
@property (nonatomic, assign) CGFloat amount;//金额
@property (nonatomic, assign) NSInteger points;//所需要的总的积分
@property (nonatomic, copy) NSString * pname;//商品名称
@property (nonatomic, copy) NSString * sname;//商品规格名称
@property (nonatomic, copy) NSString * cover;//商品封面图
@property (nonatomic, assign) NSInteger min_buy_num;//最小购买数量
@property (nonatomic, assign) NSInteger stock;//当前可用库存

@property (nonatomic, assign) BOOL isSelected;

- (void)changeToSelect;
- (void)changeToNoSelect;

@end

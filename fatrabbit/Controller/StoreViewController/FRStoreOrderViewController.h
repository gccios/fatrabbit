//
//  FRStoreOrderViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"

@protocol FRStoreOrderViewControllerDelegate <NSObject>

- (void)storeOrderHandleWithOrderID:(NSInteger)orderID;

@end

/**
 商品确认订单页面
 */
@interface FRStoreOrderViewController : FRBaseViewController

@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) CGFloat payTotalPrice;
@property (nonatomic, assign) CGFloat totalPoints;
@property (nonatomic, assign) CGFloat discountPrice;

@property (nonatomic, weak) id<FRStoreOrderViewControllerDelegate> delegate;

- (instancetype)initWithSource:(NSArray *)source;

@end

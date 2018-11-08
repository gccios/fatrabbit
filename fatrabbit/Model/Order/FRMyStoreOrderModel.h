//
//  FRMyStoreOrderModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMyInvoiceModel.h"
#import "FRStoreCartModel.h"

/**
 我的商品订单model
 */
@interface FRMyStoreOrderModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger need_invoice;
@property (nonatomic, strong) FRMyInvoiceModel * invoice;
@property (nonatomic, copy) NSString * product_name;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger order_status;

@property (nonatomic, copy) NSString * sn;
@property (nonatomic, assign) CGFloat discounts;
@property (nonatomic, assign) CGFloat balance_amount;
@property (nonatomic, assign) CGFloat pay_amount;
@property (nonatomic, assign) NSInteger pay_method;
@property (nonatomic, assign) CGFloat points;
@property (nonatomic, assign) NSInteger paystatus;
@property (nonatomic, assign) NSInteger paytime;
@property (nonatomic, assign) NSInteger addtime;
@property (nonatomic, assign) NSInteger shipping_status;
@property (nonatomic, copy) NSString * consignee;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * kfphone;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, strong) NSArray * plist;

@end

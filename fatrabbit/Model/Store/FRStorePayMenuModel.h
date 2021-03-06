//
//  FRStorePayMenuModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/18.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRPayWayModel.h"
#import "FRMyInvoiceModel.h"

typedef enum : NSUInteger {
    FRStorePayMenuType_PayWay,
    FRStorePayMenuType_Points,
    FRStorePayMenuType_Discount,
    FRStorePayMenuType_InvoiceInfo,
    FRStorePayMenuType_Remark
} FRStorePayMenuType;

/**
 商品确认订单的菜单选项model
 */
@interface FRStorePayMenuModel : NSObject

- (instancetype)initWithType:(FRStorePayMenuType)type;

@property (nonatomic, assign) FRStorePayMenuType type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSString * detail;

@property (nonatomic, assign) BOOL isChoose;

@property (nonatomic, strong) FRPayWayModel * payWay;
@property (nonatomic, strong) FRMyInvoiceModel * invoice;

@end

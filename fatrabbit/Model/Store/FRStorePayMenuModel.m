

//
//  FRStorePayMenuModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/18.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStorePayMenuModel.h"

@implementation FRStorePayMenuModel

- (instancetype)initWithType:(FRStorePayMenuType)type
{
    if (self = [super init]) {
        self.type = type;
        
        switch (type) {
            case FRStorePayMenuType_PayWay:
            {
                self.title = @"选择支付类型";
                self.payWay = [[FRPayWayModel alloc] initWithType:FRPayWayType_Wechat];
            }
                break;
                
            case FRStorePayMenuType_Points:
            {
                self.title = @"使用积分";
                self.detail = @"使用积分进行购买";
            }
                break;
                
            case FRStorePayMenuType_Discount:
            {
                self.title = @"会员折扣";
                self.detail = @"VIP享受折扣";
            }
                break;
                
            case FRStorePayMenuType_InvoiceInfo:
            {
                self.title = @"发票信息";
                FRMyInvoiceModel * invoice = [[FRMyInvoiceModel alloc] init];
                invoice.company = @"不开发票";
                self.invoice = invoice;
            }
                break;
                
            case FRStorePayMenuType_Remark:
            {
                self.title = @"备注";
                self.detail = @"";
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (void)setPayWay:(FRPayWayModel *)payWay
{
    _payWay = payWay;
    _detail = payWay.title;
}

- (void)setInvoice:(FRMyInvoiceModel *)invoice
{
    _invoice = invoice;
    _detail = invoice.company;
}

@end

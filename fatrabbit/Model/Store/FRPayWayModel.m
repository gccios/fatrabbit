//
//  FRPayWayModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRPayWayModel.h"

@implementation FRPayWayModel

- (instancetype)initWithType:(FRPayWayType)type
{
    if (self = [super init]) {
        
        self.type = type;
        switch (type) {
            case FRPayWayType_Wechat:
            {
                self.title = @"微信支付";
            }
                break;
                
            case FRPayWayType_Alipay:
            {
                self.title = @"支付宝支付";
            }
                break;
                
            case FRPayWayType_Balance:
            {
                self.title = @"余额支付";
            }
                break;
            case FRPayWayType_UnderLine:
            {
                self.title = @"货到付款线下支付";
            }
                break;
                
            case FRPayWayType_FenQi:
            {
                self.title = @"分期付款";
            }
                break;
                
            default:
                break;
        }
        
    }
    return self;
}

@end

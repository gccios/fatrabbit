//
//  FRServicePayWayModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRServicePayWayModel.h"

@implementation FRServicePayWayModel

- (instancetype)initWithType:(FRServicePayWay)type
{
    if (self = [super init]) {
        self.type = type;
        
        switch (type) {
            case FRServicePayWay_All:
                self.info = @"一口价交易，双方确认服务完成则平台完成交易";
                break;
                
            case FRServicePayWay_Half:
                self.info = @"定金尾款模式（定金50%，尾款50%）\n下单时支付定金，确认订单完成后支付尾款";
                break;
                
            case FRServicePayWay_DownLine:
                self.info = @"货到付款/线下支付";
                break;
                
            default:
                break;
        }
    }
    return self;
}

@end

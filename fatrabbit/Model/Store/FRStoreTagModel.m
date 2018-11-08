//
//  FRStoreTagModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/14.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreTagModel.h"

@implementation FRStoreTagModel

- (instancetype)initWithType:(FRStoreTagType)type
{
    if (self = [super init]) {
        self.type = type;
        
        switch (type) {
            case FRStoreTagType_VIP:
                self.title = @"会员折扣";
                break;
                
            case FRStoreTagType_PiFa:
                self.title = @"批发优惠";
                break;
                
            case FRStoreTagType_Points:
                self.title = @"积分兑换";
                break;
                
            case FRStoreTagType_GivePoints:
                self.title = @"积分奖励";
                break;
                
            case FRStoreTagType_FenQi:
                self.title = @"分期付款";
                break;
                
            default:
                break;
        }
    }
    return self;
}

@end

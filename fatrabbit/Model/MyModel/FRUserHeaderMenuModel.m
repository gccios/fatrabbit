//
//  FRUserHeaderMenuModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserHeaderMenuModel.h"

@implementation FRUserHeaderMenuModel

- (instancetype)initWithType:(FRUserHeaderMenuType)type
{
    if (self = [super init]) {
        self.type = type;
        
        if (type == FRUserHeaderMenuType_Order) {
            self.title = @"我的订单";
            self.imageName = @"myOrder";
        }else if (type == FRUserHeaderMenuType_Need) {
            self.title = @"我的需求";
            self.imageName = @"myNeed";
        }else if (type == FRUserHeaderMenuType_Collect) {
            self.title = @"我的收藏";
            self.imageName = @"myCollect";
        }else if (type == FRUserHeaderMenuType_VIP) {
            self.title = @"VIP权益";
            self.imageName = @"myVIP";
        }
    }
    return self;
}

@end

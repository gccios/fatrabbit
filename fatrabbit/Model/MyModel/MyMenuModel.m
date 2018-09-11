//
//  MyMenuModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "MyMenuModel.h"

@interface MyMenuModel ()

@end

@implementation MyMenuModel

- (instancetype)initWithType:(MyMenuType)type
{
    if (self = [super init]) {
        self.type = type;
        [self createMenuType];
    }
    return self;
}

- (void)createMenuType
{
    switch (self.type) {
        case MyMenuType_MyAccount:
            
            self.imageName = @"myAccount";
            self.title = @"我的账户";
            self.detail = @"余额、发票";
            
            break;
            
        case MyMenuType_MyAddress:
            
            self.imageName = @"myAddress";
            self.title = @"我的收货地址";
            self.detail = @"商城等使用";
            
            break;
            
        case MyMenuType_ApplyRegister:
            
            self.imageName = @"myApply";
            self.title = @"申请成为提供服务的供应商";
            self.detail = @"";
            
            break;
            
        case MyMenuType_MyIntel:
            
            self.imageName = @"myIntel";
            self.title = @"我的资质";
            self.detail = @"";
            
            break;
            
        case MyMenuType_MyExample:
            
            self.imageName = @"myExample";
            self.title = @"我的案例";
            self.detail = @"";
            
            break;
            
        case MyMenuType_MyService:
            
            self.imageName = @"myService";
            self.title = @"我的服务";
            self.detail = @"";
            
            break;
            
        case MyMenuType_MyGetOrder:
            
            self.imageName = @"myGetOrder";
            self.title = @"我的接到的订单";
            self.detail = @"";
            
            break;
            
        case MyMenuType_Advice:
            
            self.imageName = @"myAdvice";
            self.title = @"意见反馈";
            self.detail = @"";
            
            break;
            
        case MyMenuType_Setting:
            
            self.imageName = @"mySetting";
            self.title = @"设置";
            self.detail = @"";
            
            break;
            
        default:
            break;
    }
}

@end

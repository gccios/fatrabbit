//
//  MyMenuModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "MyMenuModel.h"

@interface MyMenuModel ()

@property (nonatomic, assign) MyMenuType type;

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
            
            self.imageName = @"";
            self.title = @"我的账户";
            
            break;
            
        case MyMenuType_MyAddress:
            
            self.imageName = @"";
            self.title = @"我的收货地址";
            
            break;
            
        case MyMenuType_ApplyRegister:
            
            self.imageName = @"";
            self.title = @"申请成为提供服务的供应商";
            
            break;
            
        case MyMenuType_Advice:
            
            self.imageName = @"";
            self.title = @"意见反馈";
            
            break;
            
        case MyMenuType_Setting:
            
            self.imageName = @"";
            self.title = @"设置";
            
            break;
            
        default:
            break;
    }
}

@end

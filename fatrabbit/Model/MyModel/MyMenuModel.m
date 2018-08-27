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
        [self createMenuType];
    }
    return self;
}

- (void)createMenuType
{
    switch (self.type) {
        case MyMenuType_MyAccount:
            
            break;
            
        case MyMenuType_MyAddress:
            
            break;
            
        case MyMenuType_ApplyRegister:
            
            break;
            
        case MyMenuType_Advice:
            
            break;
            
        case MyMenuType_Setting:
            
            break;
            
        default:
            break;
    }
}

@end

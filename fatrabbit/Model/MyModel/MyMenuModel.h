//
//  MyMenuModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MyMenuType_MyAccount,
    MyMenuType_MyAddress,
    MyMenuType_ApplyRegister,
    MyMenuType_MyIntel,
    MyMenuType_MyExample,
    MyMenuType_MyService,
    MyMenuType_MyGetOrder,
    MyMenuType_Advice,
    MyMenuType_Setting
} MyMenuType;

@interface MyMenuModel : NSObject

- (instancetype)initWithType:(MyMenuType)type;

@property (nonatomic, assign) MyMenuType type;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageName;
@property (nonatomic, copy) NSString * detail;

@end

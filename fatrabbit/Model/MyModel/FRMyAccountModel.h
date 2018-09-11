//
//  FRMyAccountModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FRMyAccountType_Money,
    FRMyAccountType_Point,
    FRMyAccountType_Invoice,
} FRMyAccountType;

@interface FRMyAccountModel : NSObject

- (instancetype)initWithType:(FRMyAccountType)type;

@property (nonatomic, assign) FRMyAccountType type;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;

@end

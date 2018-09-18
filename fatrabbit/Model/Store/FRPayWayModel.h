//
//  FRPayWayModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FRPayWayType_Wechat,
    FRPayWayType_Alipay,
    FRPayWayType_Balance,
    FRPayWayType_UnderLine
} FRPayWayType;

@interface FRPayWayModel : NSObject

- (instancetype)initWithType:(FRPayWayType)type;

@property (nonatomic, assign) FRPayWayType type;
@property (nonatomic, copy) NSString * title;

@end

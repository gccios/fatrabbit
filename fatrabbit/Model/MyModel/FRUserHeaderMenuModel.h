//
//  FRUserHeaderMenuModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FRUserHeaderMenuType_Order,
    FRUserHeaderMenuType_Collect,
    FRUserHeaderMenuType_Need,
    FRUserHeaderMenuType_VIP
} FRUserHeaderMenuType;

@interface FRUserHeaderMenuModel : NSObject

- (instancetype)initWithType:(FRUserHeaderMenuType)type;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageName;

@end

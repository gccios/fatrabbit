//
//  FRServicePayWayModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FRServicePayWay_All = 1,
    FRServicePayWay_Half = 2,
    FRServicePayWay_DownLine = 3,
} FRServicePayWay;

/**
 服务model
 */
@interface FRServicePayWayModel : NSObject

@property (nonatomic, assign) FRServicePayWay type;

- (instancetype)initWithType:(FRServicePayWay)type;

@property (nonatomic, copy) NSString * info;

@end

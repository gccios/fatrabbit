//
//  FRStoreTagModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/14.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FRStoreTagType_VIP,
    FRStoreTagType_PiFa,
    FRStoreTagType_Points,
    FRStoreTagType_GivePoints,
    FRStoreTagType_FenQi,
} FRStoreTagType;

@interface FRStoreTagModel : NSObject

- (instancetype)initWithType:(FRStoreTagType)type;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * title;

@end

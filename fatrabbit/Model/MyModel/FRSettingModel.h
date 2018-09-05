//
//  FRSettingModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRApplicatinInfoTool.h"

typedef enum : NSUInteger {
    FRSettingType_Cache,
    FRSettingType_Version,
    FRSettingType_AboutUs,
} FRSettingType;

@interface FRSettingModel : NSObject

- (instancetype)initWithType:(FRSettingType)type;

@property (nonatomic, assign) FRSettingType type;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;

@end

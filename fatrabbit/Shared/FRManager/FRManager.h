//
//  FRManager.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRCateModel.h"
#import "FRCityModel.h"

/**
 应用全局信息类，如城市列表，分类列表
 */
@interface FRManager : NSObject

@property (nonatomic, strong) NSMutableArray * cateList;
@property (nonatomic, strong) NSMutableArray * cityList;

@property (nonatomic, copy) NSString * kf_phone;

+ (instancetype)shareManager;

@end

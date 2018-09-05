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

@interface FRManager : NSObject

@property (nonatomic, strong) NSMutableArray * cateList;
@property (nonatomic, strong) NSMutableArray * cityList;

+ (instancetype)shareManager;

@end

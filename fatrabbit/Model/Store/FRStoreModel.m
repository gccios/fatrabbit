//
//  FRStoreModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/7.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreModel.h"

@implementation FRStoreModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"spec": @"FRStoreSpecModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"pid" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end

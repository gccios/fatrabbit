//
//  FRMessageModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMessageModel.h"

@implementation FRMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"cid" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end

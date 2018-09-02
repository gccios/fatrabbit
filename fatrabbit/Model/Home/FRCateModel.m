//
//  FRCateModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCateModel.h"

@implementation FRCateModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"child": @"FRCateModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"cid" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end

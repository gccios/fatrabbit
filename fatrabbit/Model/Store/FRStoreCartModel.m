//
//  FRStoreCartModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreCartModel.h"

@implementation FRStoreCartModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"cid" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

- (void)changeToSelect
{
    self.isSelected = YES;
}

- (void)changeToNoSelect
{
    self.isSelected = NO;
}

@end

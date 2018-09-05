//
//  FRManager.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRManager.h"

@implementation FRManager

+ (instancetype)shareManager
{
    static dispatch_once_t once;
    static FRManager * instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray *)cateList
{
    if (!_cateList) {
        _cateList = [[NSMutableArray alloc] init];
    }
    return _cateList;
}

- (NSMutableArray *)cityList
{
    if (!_cityList) {
        _cityList = [[NSMutableArray alloc] init];
    }
    return _cityList;
}

@end

//
//  FRCityListRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCityListRequest.h"

@implementation FRCityListRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"servicecity";
    }
    return self;
}

@end

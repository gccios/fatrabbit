//
//  FRVIPRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRVIPRequest.h"

@implementation FRVIPRequest

- (instancetype)initWithVIPLevelList
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"viplist";
    }
    return self;
}

@end

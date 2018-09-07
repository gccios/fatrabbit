//
//  FRStoreHomeRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/7.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreHomeRequest.h"

@implementation FRStoreHomeRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"shopindex";
    }
    return self;
}

@end

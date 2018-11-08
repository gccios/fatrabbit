//
//  FRExampleRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRExampleRequest.h"

@implementation FRExampleRequest

- (instancetype)initWithExampleList
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"mycaselist";
    }
    return self;
}

@end

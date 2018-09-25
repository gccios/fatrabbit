//
//  FRUserAccountRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/25.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserAccountRequest.h"

@implementation FRUserAccountRequest

- (instancetype)initWithBalance
{
    if (self = [super init]) {
        
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"balance";
        
    }
    return self;
}

- (instancetype)initWithPoints
{
    if (self = [super init]) {
        
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"points";
    }
    return self;
}

@end

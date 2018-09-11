//
//  FRAliyunSTSRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAliyunSTSRequest.h"

@implementation FRAliyunSTSRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"aliyunstsauth";
    }
    return self;
}

@end

//
//  FRTelLogInRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRTelLogInRequest.h"

@implementation FRTelLogInRequest

- (instancetype)initWithTel:(NSString *)telNumber code:(NSString *)code
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"mobilelogin";
        
        [self setValue:telNumber forParamKey:@"mobile"];
        [self setValue:code forParamKey:@"code"];
    }
    return self;
}

@end

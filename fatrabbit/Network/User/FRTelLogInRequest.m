//
//  FRTelLogInRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRTelLogInRequest.h"

@implementation FRTelLogInRequest

- (instancetype)initWithTel:(NSString *)mobile code:(NSString *)code
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"mobilelogin";
        
        [self setValue:mobile forParamKey:@"mobile"];
        [self setValue:code forParamKey:@"code"];
    }
    return self;
}

- (instancetype)initWithSendCode:(NSString *)mobile
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"sms";
        
        [self setValue:mobile forParamKey:@"mobile"];
        [self setIntegerValue:2 forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initWithSendBindCode:(NSString *)mobile
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"sms";
        
        [self setValue:mobile forParamKey:@"mobile"];
        [self setIntegerValue:1 forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initWithWeChatCode:(NSString *)code
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"wxlogin";
        
        [self setValue:code forParamKey:@"code"];
    }
    return self;
}

- (instancetype)initWithBindMobile:(NSString *)mobile code:(NSString *)code
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"bindmobile";
        
        [self setValue:mobile forParamKey:@"mobile"];
        [self setValue:code forParamKey:@"code"];
    }
    return self;
}

@end

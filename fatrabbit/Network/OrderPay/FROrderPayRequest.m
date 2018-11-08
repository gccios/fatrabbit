//
//  FROrderPayRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FROrderPayRequest.h"

@implementation FROrderPayRequest

- (instancetype)initWithStoreAlipayOrderID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"aliorder";
        
        [self setIntegerValue:storeID forParamKey:@"id"];
        [self setIntegerValue:1 forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initWithStoreWechatOrderID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"unifiedorder";
        
        [self setIntegerValue:storeID forParamKey:@"id"];
        [self setIntegerValue:1 forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initWithServiceAlipayOrderID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"aliorder";
        
        [self setIntegerValue:storeID forParamKey:@"id"];
        [self setIntegerValue:2 forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initWithServiceWechatOrderID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"unifiedorder";
        
        [self setIntegerValue:storeID forParamKey:@"id"];
        [self setIntegerValue:2 forParamKey:@"type"];
    }
    return self;
}

- (void)configPayType:(NSInteger)payType
{
    [self setIntegerValue:payType forParamKey:@"paytype"];
}


@end

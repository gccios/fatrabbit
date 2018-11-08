//
//  FROrderRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FROrderRequest.h"

@implementation FROrderRequest

- (instancetype)initMyStoreOrderWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"myproductorder";
        
        [self setIntegerValue:type forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initMyServiceOrderWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"myserviceorder";
        
        [self setIntegerValue:type forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initMyGetServiceOrderWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceorder";
        
        [self setIntegerValue:type forParamKey:@"type"];
    }
    return self;
}

- (instancetype)initStoreDetailWithID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"productorderinfo";
        [self setIntegerValue:storeID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initServiceDetailWithID:(NSInteger)serviceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceorderinfo";
        [self setIntegerValue:serviceID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initCancleWithID:(NSInteger)orderID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"productordercancel";
        
        [self setIntegerValue:orderID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initCancleServiceWithID:(NSInteger)serviceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceordercancel";
        
        [self setIntegerValue:serviceID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initWithCompeleteServiceWithID:(NSInteger)serviceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceordercomplete";
        
        [self setIntegerValue:serviceID forParamKey:@"id"];
    }
    return self;
}

@end

//
//  FRCollectRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCollectRequest.h"

@implementation FRCollectRequest

- (instancetype)initWithCollectList
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"collectlist";
    }
    return self;
}

- (instancetype)initWithAddNeedID:(NSInteger)needID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"collect";
        
        [self setIntegerValue:needID forParamKey:@"demand_id"];
    }
    return self;
}

- (instancetype)initWithAddServiceID:(NSInteger)serviceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"collect";
        
        [self setIntegerValue:serviceID forParamKey:@"service_id"];
    }
    return self;
}

- (instancetype)initWithAddStoreID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"collect";
        
        [self setIntegerValue:storeID forParamKey:@"product_id"];
    }
    return self;
}

- (instancetype)initWithRemoveID:(NSInteger)collectID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"collectdel";
        
        [self setIntegerValue:collectID forParamKey:@"id"];
    }
    return self;
}

@end

//
//  FRHomeIndexRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRHomeIndexRequest.h"

@implementation FRHomeIndexRequest

- (instancetype)initNeedWithPage:(NSInteger)page
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"index";
        
        [self setIntegerValue:1 forParamKey:@"type"];
        [self setIntegerValue:page forParamKey:@"page"];
    }
    return self;
}

- (instancetype)initSeriviceWithPage:(NSInteger)page
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"index";
        
        [self setIntegerValue:2 forParamKey:@"type"];
        [self setIntegerValue:page forParamKey:@"page"];
    }
    return self;
}

- (instancetype)initCateNeedWithCateID:(NSInteger)cateID page:(NSInteger)page
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"demandlist";
        
        [self setIntegerValue:cateID forParamKey:@"cateid"];
        [self setIntegerValue:page forParamKey:@"page"];
    }
    return self;
}

- (instancetype)initCateServiceWithCateID:(NSInteger)cateID page:(NSInteger)page
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"servicelist";
        
        [self setIntegerValue:cateID forParamKey:@"cateid"];
        [self setIntegerValue:page forParamKey:@"page"];
    }
    return self;
}

- (instancetype)initCateAdvWithCateID:(NSInteger)cateID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"cateadv";
        
        [self setIntegerValue:cateID forParamKey:@"cateid"];
    }
    return self;
}

@end

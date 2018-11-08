//
//  FRNeedListRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRNeedListRequest.h"

@implementation FRNeedListRequest

- (instancetype)initWithMyNeedList
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"mydemand";
        
        [self setIntegerValue:1 forParamKey:@"status"];
    }
    return self;
}

- (instancetype)initWithDeleteNeedID:(NSInteger)needID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"demandcancel";
        
        [self setIntegerValue:needID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initWithCateID:(NSInteger)cateID page:(NSInteger)page
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"demandlist";
        
        if (cateID != 0) {
            [self setIntegerValue:cateID forParamKey:@"cateid"];
        }
        [self setIntegerValue:page forParamKey:@"page"];
    }
    return self;
}

@end

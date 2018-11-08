//
//  FRNeedDetailRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRNeedDetailRequest.h"

@implementation FRNeedDetailRequest

- (instancetype)initWithNeedID:(NSInteger)needID
{
    if (self = [super init]) {
        
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"demandinfo";
        
        [self setIntegerValue:needID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initContactWithNeedID:(NSInteger)needID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"demandcontact";
        
        [self setIntegerValue:needID forParamKey:@"id"];
    }
    return self;
}

@end

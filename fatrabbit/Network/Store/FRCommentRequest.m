//
//  FRCommentRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCommentRequest.h"

@implementation FRCommentRequest

- (instancetype)initWithStoreID:(NSInteger)storeID level:(NSInteger)level service_star:(NSInteger)service_star company_star:(NSInteger)company_star business_star:(NSInteger)business_star content:(NSString *)content
{
    if (self = [super init]) {
        
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"productorderfeedback";
        
        [self setIntegerValue:storeID forParamKey:@"id"];
        [self setIntegerValue:level forParamKey:@"level"];
        [self setIntegerValue:service_star forParamKey:@"service_star"];
        [self setIntegerValue:company_star forParamKey:@"company_star"];
        [self setIntegerValue:business_star forParamKey:@"business_star"];
        [self setValue:content forParamKey:@"content"];
    }
    return self;
}

- (instancetype)initServiceComentWithStoreID:(NSInteger)storeID level:(NSInteger)level service_star:(NSInteger)service_star company_star:(NSInteger)company_star business_star:(NSInteger)business_star content:(NSString *)content
{
    if (self = [super init]) {
        
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceorderfeedback";
        
        [self setIntegerValue:storeID forParamKey:@"id"];
        [self setIntegerValue:level forParamKey:@"level"];
        [self setIntegerValue:service_star forParamKey:@"service_star"];
        [self setIntegerValue:company_star forParamKey:@"company_star"];
        [self setIntegerValue:business_star forParamKey:@"business_star"];
        [self setValue:content forParamKey:@"content"];
    }
    return self;
}

@end

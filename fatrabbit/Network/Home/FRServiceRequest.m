//
//  FRServiceRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRServiceRequest.h"

@implementation FRServiceRequest

- (instancetype)initWithMySerivice
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"myservice";
    }
    return self;
}

- (instancetype)initDetailWithSeriviceID:(NSInteger)serviceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceinfo";
        
        [self setIntegerValue:serviceID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initDeleteWithID:(NSInteger)serviceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"servicedelete";
        
        [self setIntegerValue:serviceID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initPublishWithPrice:(double)price title:(NSString *)title remark:(NSString *)remark img:(NSArray *)images cateID:(NSInteger)cateID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"servicepub";
        
        [self setIntegerValue:cateID forParamKey:@"cate_id"];
        [self setDoubleValue:price forParamKey:@"amount"];
        if (isEmptyString(remark)) {
            [self setValue:@"" forParamKey:@"remark"];
        }else{
            [self setValue:remark forParamKey:@"remark"];
        }
        
        if (isEmptyString(title)) {
            [self setValue:@"" forParamKey:@"title"];
        }else{
            [self setValue:title forParamKey:@"title"];
        }
        
        if (images && images.count > 0) {
            [self setValue:images forParamKey:@"img"];
            
        }
    }
    return self;
}

- (void)configEditWithID:(NSInteger)seriviceID
{
    self.methodName = @"serviceedit";
    [self setIntegerValue:seriviceID forParamKey:@"id"];
}

- (instancetype)initEditWithID:(NSInteger)seriviceID price:(double)price title:(NSString *)title remark:(NSString *)remark img:(NSArray *)images cateID:(NSInteger)cateID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceedit";
        
        [self setIntegerValue:seriviceID forParamKey:@"id"];
        [self setIntegerValue:cateID forParamKey:@"cate_id"];
        [self setDoubleValue:price forParamKey:@"amount"];
        if (isEmptyString(remark)) {
            [self setValue:@"" forParamKey:@"remark"];
        }else{
            [self setValue:remark forParamKey:@"remark"];
        }
        
        if (isEmptyString(title)) {
            [self setValue:@"" forParamKey:@"title"];
        }else{
            [self setValue:title forParamKey:@"title"];
        }
        
        if (images && images.count > 0) {
            [self setValue:images forParamKey:@"img"];
            
        }
    }
    return self;
}

- (instancetype)initWithAddOrderWithID:(NSInteger)serviceID payWay:(NSInteger)payWay number:(NSInteger)number remark:(NSString *)remark images:(NSArray *)images paymethod:(NSInteger)paymethod
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceorderadd";
        
        [self setIntegerValue:serviceID forParamKey:@"service_id"];
        [self setIntegerValue:number forParamKey:@"num"];
        [self setIntegerValue:payWay forParamKey:@"paytype"];
        [self setIntegerValue:paymethod forParamKey:@"paymethod"];
        [self setValue:remark forParamKey:@"remark"];
        [self setValue:images forParamKey:@"img"];
    }
    return self;
}

@end

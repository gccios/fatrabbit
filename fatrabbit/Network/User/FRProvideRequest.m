//
//  FRProvideRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRProvideRequest.h"

@implementation FRProvideRequest

- (instancetype)initWithProvideDetail
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceproviderinfo";
    }
    return self;
}

- (instancetype)initWithCateID:(NSInteger)cateID cityID:(NSInteger)cityID mobile:(NSString *)mobile imgs:(NSArray *)imgs business_license:(NSString *)business_license remark:(NSString *)remark name:(NSString *)name
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"serviceproviderapply";
        
        [self setIntegerValue:cateID forParamKey:@"cate_id"];
        [self setIntegerValue:cityID forParamKey:@"region_id"];
        [self setValue:mobile forParamKey:@"mobile"];
        [self setValue:business_license forParamKey:@"business_license"];
        [self setValue:imgs forParamKey:@"imgs"];
        [self setValue:remark forParamKey:@"remark"];
        [self setValue:name forParamKey:@"name"];
    }
    return self;
}

@end

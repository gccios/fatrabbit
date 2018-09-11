//
//  FRUserAddressRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserAddressRequest.h"

@implementation FRUserAddressRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"addresslist";
    }
    return self;
}

- (instancetype)initAddWith:(NSString *)name tel:(NSString *)mobile address:(NSString *)address
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"addressadd";
        
        [self setValue:name forParamKey:@"consignee"];
        [self setValue:mobile forParamKey:@"mobile"];
        [self setValue:address forParamKey:@"address"];
    }
    return self;
}

- (instancetype)initEditWith:(NSString *)name tel:(NSString *)mobile address:(NSString *)address addressID:(NSInteger)uid
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"addressedit";
        
        [self setValue:name forParamKey:@"consignee"];
        [self setValue:mobile forParamKey:@"mobile"];
        [self setValue:address forParamKey:@"address"];
        [self setIntegerValue:uid forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initDeleteWith:(NSInteger)cid
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"addressdel";
        
        [self setIntegerValue:cid forParamKey:@"id"];
    }
    return self;
}

@end

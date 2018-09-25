//
//  FRStoreOrderRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/24.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreOrderRequest.h"

@implementation FRStoreOrderRequest

- (instancetype)initWithPayWithAddressID:(NSInteger)addressID invoiceID:(NSInteger)invoiceID payWay:(NSInteger)payWay reamrk:(NSString *)remark cartIDs:(NSArray *)cartIDs
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"productorderadd";
        
        [self setIntegerValue:addressID forParamKey:@"address_id"];
        [self setIntegerValue:addressID forParamKey:@"invoice_id"];
        [self setIntegerValue:addressID forParamKey:@"paymethod"];
        [self setValue:remark forParamKey:@"remark"];
        [self setValue:cartIDs forParamKey:@"cart_ids"];
    }
    return self;
}

@end

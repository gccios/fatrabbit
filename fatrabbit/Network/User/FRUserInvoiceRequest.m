//
//  FRUserInvoiceRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/16.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserInvoiceRequest.h"

@implementation FRUserInvoiceRequest

- (instancetype)initWithGetList
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"invoicelist";
    }
    return self;
}

- (instancetype)initAddWith:(NSString *)company number:(NSString *)number address:(NSString *)address mobile:(NSString *)mobile bank:(NSString *)bank bankAccount:(NSString *)banAccount
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"invoiceadd";
        
        [self setValue:company forParamKey:@"company"];
        [self setValue:number forParamKey:@"idnumber"];
        [self setValue:address forParamKey:@"address"];
        [self setValue:mobile forParamKey:@"phone"];
        [self setValue:bank forParamKey:@"bankname"];
        [self setValue:banAccount forParamKey:@"bankaccount"];
    }
    return self;
}

- (instancetype)initEditWith:(NSString *)company number:(NSString *)number address:(NSString *)address mobile:(NSString *)mobile bank:(NSString *)bank bankAccount:(NSString *)banAccount invoiceID:(NSInteger)invoiceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"invoiceedit";
        
        [self setValue:company forParamKey:@"company"];
        [self setValue:number forParamKey:@"idnumber"];
        [self setValue:address forParamKey:@"address"];
        [self setValue:mobile forParamKey:@"phone"];
        [self setValue:bank forParamKey:@"bankname"];
        [self setValue:banAccount forParamKey:@"bankaccount"];
        [self setIntegerValue:invoiceID forParamKey:@"id"];
    }
    return self;
}

- (instancetype)initDeleteWithInvoiceID:(NSInteger)invoiceID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"invoicedel";
        
        [self setIntegerValue:invoiceID forParamKey:@"id"];
    }
    return self;
}

@end

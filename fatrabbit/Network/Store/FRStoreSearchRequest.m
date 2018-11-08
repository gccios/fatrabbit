//
//  FRStoreSearchRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreSearchRequest.h"

@implementation FRStoreSearchRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"productsearch";
    }
    return self;
}

- (void)configWithCateID:(NSInteger)cateID
{
    if (cateID != 0) {
        [self setIntegerValue:cateID forParamKey:@"cate_id"];
    }
}

- (void)configWithKeyWord:(NSString *)keyWord
{
    [self setValue:keyWord forParamKey:@"keyword"];
}

- (void)configWithBlockID:(NSInteger)blockID
{
    if (blockID != 0) {
        [self setIntegerValue:blockID forParamKey:@"label_id"];
    }
}

- (void)configPriceUp
{
    [self setValue:@"price" forParamKey:@"order"];
    [self setValue:@"asc" forParamKey:@"order_type"];
}

- (void)configPriceDown
{
    [self setValue:@"price" forParamKey:@"order"];
    [self setValue:@"desc" forParamKey:@"order_type"];
}

- (void)configDealNumber
{
    [self setValue:@"order_num" forParamKey:@"order"];
}

@end

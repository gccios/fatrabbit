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
    [self setIntegerValue:cateID forParamKey:@"cate_id"];
}

- (void)configWithKeyWord:(NSString *)keyWord
{
    [self setValue:keyWord forParamKey:@"keyword"];
}

@end

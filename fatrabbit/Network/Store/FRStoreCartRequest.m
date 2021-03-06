//
//  FRStoreCartRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreCartRequest.h"

@implementation FRStoreCartRequest

- (instancetype)initWithStoreList
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"cartlist";
    }
    return self;
}

- (instancetype)initAddWithStoreID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"cartedit";
        
        [self setIntegerValue:1 forParamKey:@"type"];
        [self setIntegerValue:storeID forParamKey:@"sid"];
    }
    return self;
}

- (instancetype)initDeleteWithStoreID:(NSInteger)storeID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"cartedit";
        
        [self setIntegerValue:0 forParamKey:@"type"];
        [self setIntegerValue:storeID forParamKey:@"sid"];
    }
    return self;
}

- (instancetype)initRemovetWithStoreIDs:(NSArray *)storeIDs
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"cartdelete";
        
        [self setValue:storeIDs forParamKey:@"cart_ids"];
    }
    return self;
}

- (void)configWithCardIDList:(NSArray *)cardList
{
    [self setValue:cardList forParamKey:@"cart_ids"];
}

- (void)configWithNum:(NSInteger)num
{
    [self setIntegerValue:num forParamKey:@"num"];
}

@end

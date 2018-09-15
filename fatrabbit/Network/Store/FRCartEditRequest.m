//
//  FRCartEditRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCartEditRequest.h"

@implementation FRCartEditRequest

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

@end

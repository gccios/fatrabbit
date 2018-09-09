//
//  FRStoreDetailRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreDetailRequest.h"

@implementation FRStoreDetailRequest

- (instancetype)initWithID:(NSInteger)cid
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"product";
        
        [self setIntegerValue:cid forParamKey:@"id"];
    }
    return self;
}

@end

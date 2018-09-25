//
//  FRNeedListRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRNeedListRequest.h"

@implementation FRNeedListRequest

- (instancetype)initWithCateID:(NSInteger)cateID page:(NSInteger)page
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"demandlist";
        
        if (cateID != 0) {
            [self setIntegerValue:cateID forParamKey:@"cateid"];
        }
        [self setIntegerValue:page forParamKey:@"page"];
    }
    return self;
}

@end

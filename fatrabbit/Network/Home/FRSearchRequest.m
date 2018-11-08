//
//  FRSearchRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRSearchRequest.h"

@implementation FRSearchRequest

- (instancetype)initIndexSearchWithPage:(NSInteger)page keyword:(NSString *)keyword
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"indexsearch";
        
        [self setIntegerValue:page forParamKey:@"page"];
        if (!isEmptyString(keyword)) {
            [self setValue:keyword forParamKey:@"keyword"];
        }
    }
    return self;
}

@end

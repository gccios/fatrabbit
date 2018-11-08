//
//  FRMessageRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMessageRequest.h"

@implementation FRMessageRequest

- (instancetype)initWithMessageListPage:(NSInteger)page
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"mymsg";
        
        [self setIntegerValue:page forParamKey:@"page"];
    }
    return self;
}

@end

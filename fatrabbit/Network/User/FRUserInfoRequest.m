//
//  FRUserInfoRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserInfoRequest.h"

@implementation FRUserInfoRequest

- (instancetype)initWithUserID:(NSInteger)userID
{
    if (self = [super init]) {
        
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"cardinfo";
        [self setIntegerValue:userID forParamKey:@"target"];
        
    }
    return self;
}

@end

//
//  FRPushRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRPushRequest.h"

@implementation FRPushRequest

- (instancetype)initJPushReportWithID:(NSString *)reportID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"jpushreport";
        
        [self setValue:reportID forParamKey:@"id"];
    }
    return self;
}

@end

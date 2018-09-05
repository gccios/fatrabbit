//
//  FRUserReportCityRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserReportCityRequest.h"

@implementation FRUserReportCityRequest

- (instancetype)initWithCityID:(NSInteger)cityID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"cityreport";
        
        [self setIntegerValue:cityID forParamKey:@"cityid"];
    }
    return self;
}

@end

//
//  FRAdviceRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAdviceRequest.h"

@implementation FRAdviceRequest

- (instancetype)initWithMobile:(NSString *)mobile content:(NSString *)content images:(NSArray *)images
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"feedback";
        
        [self setValue:mobile forParamKey:@"mobile"];
        [self setValue:content forParamKey:@"content"];
        [self setValue:images forParamKey:@"img"];
    }
    return self;
}

@end

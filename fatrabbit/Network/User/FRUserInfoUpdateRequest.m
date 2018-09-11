//
//  FRUserInfoUpdateRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserInfoUpdateRequest.h"

@implementation FRUserInfoUpdateRequest

- (instancetype)initWithNickName:(NSString *)nickName avatar:(NSString *)avatar
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"editcard";
        
        if (!isEmptyString(nickName)) {
            [self setValue:nickName forParamKey:@"nickname"];
        }
        
        if (!isEmptyString(avatar)) {
            [self setValue:avatar forParamKey:@"avatar"];
        }
    }
    return self;
}

@end

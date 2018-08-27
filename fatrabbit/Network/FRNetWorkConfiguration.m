//
//  FRNetWorkConfiguration.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRNetWorkConfiguration.h"

@implementation FRNetWorkConfiguration

-(NSString *)baseURLString {
    return HOSTURL;
}

- (BOOL)shouldBusinessSuccessWithResponseData:(NSDictionary *)responseData task:(NSURLSessionDataTask *)task request:(BGNetworkRequest *)request {
    NSInteger code;
    code = [responseData[@"code"] integerValue];
    if(code == 1){
        return YES;
    }
    return NO;
}

@end

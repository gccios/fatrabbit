//
//  FRPulishNeedRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRPulishNeedRequest.h"

@implementation FRPulishNeedRequest

- (instancetype)initWithPrice:(float)price title:(NSString *)title remark:(NSString *)remark img:(NSArray *)images cateID:(NSInteger)cateID
{
    if (self = [super init]) {
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.methodName = @"demandpub";
        
        [self setIntegerValue:cateID forParamKey:@"cate_id"];
        [self setDoubleValue:price forParamKey:@"amount"];
        if (isEmptyString(remark)) {
            [self setValue:@"" forParamKey:@"remark"];
        }else{
            [self setValue:remark forParamKey:@"remark"];
        }
        
        if (isEmptyString(title)) {
            [self setValue:@"" forParamKey:@"title"];
        }else{
            [self setValue:title forParamKey:@"title"];
        }
        
        if (images && images.count > 0) {
            [self setValue:images forParamKey:@"img"];
            
        }
    }
    return self;
}

@end

//
//  FRPulishNeedRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRPulishNeedRequest : FRBaseNetworkRequest

- (instancetype)initWithPrice:(float)price title:(NSString *)title remark:(NSString *)remark img:(NSArray *)images cateID:(NSInteger)cateID;

@end

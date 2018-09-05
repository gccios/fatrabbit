//
//  FRUserInfoRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRUserInfoRequest : FRBaseNetworkRequest

- (instancetype)initWithUserID:(NSInteger)userID;

@end

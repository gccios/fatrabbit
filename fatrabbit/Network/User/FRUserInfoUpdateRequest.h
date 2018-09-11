//
//  FRUserInfoUpdateRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRUserInfoUpdateRequest : FRBaseNetworkRequest

- (instancetype)initWithNickName:(NSString *)nickName avatar:(NSString *)avatar;

@end

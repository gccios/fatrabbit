//
//  FRUserAccountRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/25.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRUserAccountRequest : FRBaseNetworkRequest

- (instancetype)initWithBalance;

- (instancetype)initWithPoints;

@end

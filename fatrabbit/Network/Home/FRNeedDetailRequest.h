//
//  FRNeedDetailRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRNeedDetailRequest : FRBaseNetworkRequest

- (instancetype)initWithNeedID:(NSInteger)needID;

- (instancetype)initContactWithNeedID:(NSInteger)needID;

@end

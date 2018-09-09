//
//  FRStoreDetailRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRStoreDetailRequest : FRBaseNetworkRequest

- (instancetype)initWithID:(NSInteger)cid;

@end

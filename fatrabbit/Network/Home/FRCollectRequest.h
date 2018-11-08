//
//  FRCollectRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRCollectRequest : FRBaseNetworkRequest

- (instancetype)initWithCollectList;

- (instancetype)initWithAddNeedID:(NSInteger)needID;

- (instancetype)initWithAddServiceID:(NSInteger)serviceID;

- (instancetype)initWithAddStoreID:(NSInteger)storeID;

- (instancetype)initWithRemoveID:(NSInteger)collectID;

@end

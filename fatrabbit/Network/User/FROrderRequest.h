//
//  FROrderRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FROrderRequest : FRBaseNetworkRequest

- (instancetype)initMyStoreOrderWithType:(NSInteger)type;

- (instancetype)initMyServiceOrderWithType:(NSInteger)type;

- (instancetype)initMyGetServiceOrderWithType:(NSInteger)type;

- (instancetype)initStoreDetailWithID:(NSInteger)storeID;

- (instancetype)initServiceDetailWithID:(NSInteger)serviceID;

- (instancetype)initCancleWithID:(NSInteger)orderID;

- (instancetype)initCancleServiceWithID:(NSInteger)serviceID;

- (instancetype)initWithCompeleteServiceWithID:(NSInteger)serviceID;

@end

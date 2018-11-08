//
//  FROrderPayRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FROrderPayRequest : FRBaseNetworkRequest

- (instancetype)initWithStoreAlipayOrderID:(NSInteger)storeID;

- (instancetype)initWithStoreWechatOrderID:(NSInteger)storeID;

- (instancetype)initWithServiceAlipayOrderID:(NSInteger)storeID;

- (instancetype)initWithServiceWechatOrderID:(NSInteger)storeID;


/**
 定金尾款付款类型
 @param payType 1为定金，2为尾款
 */
- (void)configPayType:(NSInteger)payType;

@end

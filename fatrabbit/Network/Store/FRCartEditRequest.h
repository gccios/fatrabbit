//
//  FRCartEditRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRCartEditRequest : FRBaseNetworkRequest

- (instancetype)initAddWithStoreID:(NSInteger)storeID;

- (instancetype)initDeleteWithStoreID:(NSInteger)storeID;

@end

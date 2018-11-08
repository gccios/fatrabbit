//
//  FRStoreCartRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRStoreCartRequest : FRBaseNetworkRequest

- (instancetype)initWithStoreList;

- (instancetype)initAddWithStoreID:(NSInteger)storeID;

- (instancetype)initDeleteWithStoreID:(NSInteger)storeID;

- (instancetype)initRemovetWithStoreIDs:(NSArray *)storeIDs;

- (void)configWithCardIDList:(NSArray *)cardList;

- (void)configWithNum:(NSInteger)num;

@end

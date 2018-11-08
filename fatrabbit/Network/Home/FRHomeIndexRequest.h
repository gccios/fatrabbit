//
//  FRHomeIndexRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRHomeIndexRequest : FRBaseNetworkRequest

- (instancetype)initNeedWithPage:(NSInteger)page;

- (instancetype)initSeriviceWithPage:(NSInteger)page;

- (instancetype)initCateNeedWithCateID:(NSInteger)cateID page:(NSInteger)page;

- (instancetype)initCateServiceWithCateID:(NSInteger)cateID page:(NSInteger)page;

- (instancetype)initCateAdvWithCateID:(NSInteger)cateID;

@end

//
//  FRNeedListRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRNeedListRequest : FRBaseNetworkRequest

- (instancetype)initWithMyNeedList;

- (instancetype)initWithDeleteNeedID:(NSInteger)needID;

- (instancetype)initWithCateID:(NSInteger)cateID page:(NSInteger)page;

@end

//
//  FRStoreSearchRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRStoreSearchRequest : FRBaseNetworkRequest

- (void)configWithCateID:(NSInteger)cateID;

- (void)configWithKeyWord:(NSString *)keyWord;

@end

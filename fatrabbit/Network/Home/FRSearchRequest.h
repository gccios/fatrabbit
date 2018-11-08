//
//  FRSearchRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRSearchRequest : FRBaseNetworkRequest

- (instancetype)initIndexSearchWithPage:(NSInteger)page keyword:(NSString *)keyword;

@end

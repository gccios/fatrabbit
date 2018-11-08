//
//  FRMessageRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRMessageRequest : FRBaseNetworkRequest

- (instancetype)initWithMessageListPage:(NSInteger)page;

@end

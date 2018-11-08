//
//  FRCommentRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRCommentRequest : FRBaseNetworkRequest

- (instancetype)initWithStoreID:(NSInteger)storeID level:(NSInteger)level service_star:(NSInteger)service_star company_star:(NSInteger)company_star business_star:(NSInteger)business_star content:(NSString *)content;

- (instancetype)initServiceComentWithStoreID:(NSInteger)storeID level:(NSInteger)level service_star:(NSInteger)service_star company_star:(NSInteger)company_star business_star:(NSInteger)business_star content:(NSString *)content;


@end

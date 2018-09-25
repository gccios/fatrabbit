//
//  FRStoreOrderRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/24.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRStoreOrderRequest : FRBaseNetworkRequest

- (instancetype)initWithPayWithAddressID:(NSInteger)addressID invoiceID:(NSInteger)invoiceID payWay:(NSInteger)payWay reamrk:(NSString *)remark cartIDs:(NSArray *)cartIDs;

@end

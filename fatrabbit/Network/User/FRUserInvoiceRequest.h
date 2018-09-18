//
//  FRUserInvoiceRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/16.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

/**
 发票请求类
 */
@interface FRUserInvoiceRequest : FRBaseNetworkRequest

- (instancetype)initWithGetList;

- (instancetype)initAddWith:(NSString *)company number:(NSString *)number address:(NSString *)address mobile:(NSString *)mobile bank:(NSString *)bank bankAccount:(NSString *)banAccount;

- (instancetype)initEditWith:(NSString *)company number:(NSString *)number address:(NSString *)address mobile:(NSString *)mobile bank:(NSString *)bank bankAccount:(NSString *)banAccount invoiceID:(NSInteger)invoiceID;

- (instancetype)initDeleteWithInvoiceID:(NSInteger)invoiceID;

@end

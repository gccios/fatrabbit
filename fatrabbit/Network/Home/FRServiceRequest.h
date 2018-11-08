//
//  FRServiceRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRServiceRequest : FRBaseNetworkRequest

- (instancetype)initWithMySerivice;

- (instancetype)initDetailWithSeriviceID:(NSInteger)serviceID;

- (instancetype)initDeleteWithID:(NSInteger)serviceID;

- (instancetype)initPublishWithPrice:(double)price title:(NSString *)title remark:(NSString *)remark img:(NSArray *)images cateID:(NSInteger)cateID;

- (void)configEditWithID:(NSInteger)seriviceID;

- (instancetype)initEditWithID:(NSInteger)seriviceID price:(double)price title:(NSString *)title remark:(NSString *)remark img:(NSArray *)images cateID:(NSInteger)cateID;

//服务下单
- (instancetype)initWithAddOrderWithID:(NSInteger)serviceID payWay:(NSInteger)payWay number:(NSInteger)number remark:(NSString *)remark images:(NSArray *)images paymethod:(NSInteger)paymethod;

@end

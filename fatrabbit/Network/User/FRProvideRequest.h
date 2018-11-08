//
//  FRProvideRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRProvideRequest : FRBaseNetworkRequest

- (instancetype)initWithProvideDetail;

- (instancetype)initWithCateID:(NSInteger)cateID cityID:(NSInteger)cityID mobile:(NSString *)mobile imgs:(NSArray *)imgs business_license:(NSString *)business_license remark:(NSString *)remark name:(NSString *)name;

@end

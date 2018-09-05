//
//  FRUserAddressRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRUserAddressRequest : FRBaseNetworkRequest

- (instancetype)initAddWith:(NSString *)name tel:(NSString *)telNumber address:(NSString *)address;

- (instancetype)initEditWith:(NSString *)name tel:(NSString *)telNumber address:(NSString *)address addressID:(NSInteger)uid;

- (instancetype)initDeleteWith:(NSInteger)cid;

@end

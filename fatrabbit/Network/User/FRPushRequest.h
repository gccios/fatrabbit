//
//  FRPushRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRPushRequest : FRBaseNetworkRequest

- (instancetype)initJPushReportWithID:(NSString *)reportID;

@end

//
//  FRAdviceRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRAdviceRequest : FRBaseNetworkRequest

- (instancetype)initWithMobile:(NSString *)mobile content:(NSString *)content images:(NSArray *)images;

@end

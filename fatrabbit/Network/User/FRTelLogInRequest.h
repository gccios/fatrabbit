//
//  FRTelLogInRequest.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"

@interface FRTelLogInRequest : FRBaseNetworkRequest

- (instancetype)initWithTel:(NSString *)mobile code:(NSString *)code;

- (instancetype)initWithSendCode:(NSString *)mobile;

- (instancetype)initWithWeChatCode:(NSString *)code;

- (instancetype)initWithBindMobile:(NSString *)mobile code:(NSString *)code;

- (instancetype)initWithSendBindCode:(NSString *)mobile;

@end

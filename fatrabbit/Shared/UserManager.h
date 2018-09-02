//
//  UserManager.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString * telNumber;
@property (nonatomic, copy) NSString * token;

- (void)loginSuccesWithCache:(NSDictionary *)data;

- (void)loginSuccessWithUid:(NSInteger)uid token:(NSString *)token telNumber:(NSString *)telNumber;

@end

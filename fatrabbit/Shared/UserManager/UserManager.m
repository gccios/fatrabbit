//
//  UserManager.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "UserManager.h"

NSString * const DDUserLoginStatusDidChange = @"DDUserLoginStatusDidChange";

@implementation UserManager

+ (instancetype)shareManager
{
    static dispatch_once_t once;
    static UserManager * instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)loginSuccesWithCache:(NSDictionary *)data
{
    [UserManager shareManager].uid = [[data objectForKey:@"uid"] integerValue];
    [UserManager shareManager].token = [data objectForKey:@"token"];
    [UserManager shareManager].telNumber = [data objectForKey:@"telNumber"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DDUserLoginStatusDidChange object:nil];
}

- (void)loginSuccessWithUid:(NSInteger)uid token:(NSString *)token telNumber:(NSString *)telNumber
{
    [UserManager shareManager].uid = uid;
    [UserManager shareManager].token = token;
    [UserManager shareManager].telNumber = telNumber;
    
    NSDictionary * dict = @{@"uid":[NSNumber numberWithInteger:uid],
                            @"token" : token,
                            @"telNumber" : telNumber
                            };
    
    [dict writeToFile:FRUserInfoPath atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DDUserLoginStatusDidChange object:nil];
}

- (NSMutableArray *)addressList
{
    if (!_addressList) {
        _addressList = [[NSMutableArray alloc] init];
    }
    return _addressList;
}

@end

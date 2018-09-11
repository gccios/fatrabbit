//
//  UserManager.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "UserManager.h"

NSString * const FRUserLoginStatusDidChange = @"FRUserLoginStatusDidChange";

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
    [self mj_setKeyValues:data];
    self.isLogin = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:FRUserLoginStatusDidChange object:nil];
}

- (void)loginSuccessWithUid:(NSInteger)uid token:(NSString *)token mobile:(NSString *)mobile
{
    [UserManager shareManager].uid = uid;
    [UserManager shareManager].token = token;
    [UserManager shareManager].mobile = mobile;
    
    NSDictionary * dict = @{@"uid":[NSNumber numberWithInteger:uid],
                            @"token" : token,
                            @"mobile" : mobile
                            };
    
    [dict writeToFile:FRUserInfoPath atomically:YES];
    self.isLogin = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:FRUserLoginStatusDidChange object:nil];
}

- (void)needUpdateLocalUserInfo
{
    NSInteger uid = [UserManager shareManager].uid;
    NSString * token = [UserManager shareManager].token;
    NSString * mobile = [UserManager shareManager].mobile;
    
    NSString * nickname = [UserManager shareManager].nickname;
    if (isEmptyString(nickname)) {
        nickname = @"";
    }
    
    NSString * avatar = [UserManager shareManager].avatar;
    if (isEmptyString(avatar)) {
        avatar = @"";
    }
    
    NSString * username = [UserManager shareManager].username;
    if (isEmptyString(username)) {
        username = @"";
    }
    
    NSInteger is_provider = [UserManager shareManager].is_provider;
    NSInteger city_id = [UserManager shareManager].city_id;
    
    NSDictionary * dict = @{@"uid":[NSNumber numberWithInteger:uid],
                            @"token" : token,
                            @"mobile" : mobile,
                            @"nickname" : nickname,
                            @"avatar" : avatar,
                            @"username" : username,
                            @"is_provider" : [NSNumber numberWithInteger:is_provider],
                            @"city_id" : [NSNumber numberWithInteger:city_id]
                            };
    
    [dict writeToFile:FRUserInfoPath atomically:YES];
    self.isLogin = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:FRUserLoginStatusDidChange object:nil];
}

- (NSMutableArray *)addressList
{
    if (!_addressList) {
        _addressList = [[NSMutableArray alloc] init];
    }
    return _addressList;
}

@end

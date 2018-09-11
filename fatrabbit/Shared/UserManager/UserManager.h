//
//  UserManager.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>
#import "FRCityModel.h"
#import "FRAddressModel.h"

extern NSString * const FRUserLoginStatusDidChange; //用户退出通知

@interface UserManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString * token;

@property (nonatomic, copy) NSString * nickname;//用户昵称
@property (nonatomic, copy) NSString * avatar;//用户头像
@property (nonatomic, copy) NSString * mobile;//用户手机
@property (nonatomic, copy) NSString * username;//用户名字
@property (nonatomic, assign) NSInteger is_provider;//是否是服务商
@property (nonatomic, assign) NSInteger city_id;//城市ID
@property (nonatomic, assign) CGFloat balance;//账户余额
@property (nonatomic, assign) NSInteger points;//可用积分

@property (nonatomic, strong) FRCityModel * city;

@property (nonatomic, strong) NSMutableArray * addressList;


- (void)loginSuccesWithCache:(NSDictionary *)data;

- (void)loginSuccessWithUid:(NSInteger)uid token:(NSString *)token mobile:(NSString *)mobile;

- (void)needUpdateLocalUserInfo;

@end

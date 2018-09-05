//
//  UserManager.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "FRCityModel.h"
#import "FRAddressModel.h"

extern NSString * const DDUserLoginStatusDidChange; //用户退出通知

@interface UserManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString * telNumber;
@property (nonatomic, copy) NSString * token;

@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, assign) NSInteger is_provider;
@property (nonatomic, assign) NSInteger city_id;

@property (nonatomic, strong) FRCityModel * city;

@property (nonatomic, strong) NSMutableArray * addressList;


- (void)loginSuccesWithCache:(NSDictionary *)data;

- (void)loginSuccessWithUid:(NSInteger)uid token:(NSString *)token telNumber:(NSString *)telNumber;

@end

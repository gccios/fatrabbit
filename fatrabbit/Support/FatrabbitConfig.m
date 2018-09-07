//
//  FatrabbitConfig.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FatrabbitConfig.h"
#import <IQKeyboardManager.h>
#import <BGNetwork.h>
#import "FRNetWorkConfiguration.h"
#import "GCCKeyChain.h"
#import "UserManager.h"
#import "FRManager.h"
#import "FRCateListRequest.h"
#import "FRCityListRequest.h"

@implementation FatrabbitConfig

//配置fatrabbit基础项
+ (void)configFatrabbitApplication
{
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[FRNetWorkConfiguration configuration]];
    
    //利用keyChain存储，仿造设备唯一标识
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (![GCCKeyChain load:keychainID]) {
        [GCCKeyChain save:keychainID data:identifierNumber];
    }
    
    //第三方键盘管理设置
    IQKeyboardManager * keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:FRUserInfoPath]) {
        NSDictionary * data = [NSDictionary dictionaryWithContentsOfFile:FRUserInfoPath];
        if ([data isKindOfClass:[NSDictionary class]]) {
            [[UserManager shareManager] loginSuccesWithCache:data];
        }
    }
}

+ (void)configFatrabbitApplicationWithNetworkData
{
    [self requestFatrabbitCateInfo];
    [self requestFatrabbitCityInfo];
}

//获取分类列表
+ (void)requestFatrabbitCateInfo
{
    FRCateListRequest * request = [[FRCateListRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                [FRManager shareManager].cateList = [FRCateModel mj_objectArrayWithKeyValuesArray:data];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

//获取城市列表
+ (void)requestFatrabbitCityInfo
{
    FRCityListRequest * cityRequest = [[FRCityListRequest alloc] init];
    [cityRequest sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                NSMutableArray * cityList = [[NSMutableArray alloc] init];
                
                for (NSDictionary * dict in data) {
                    FRCityModel * model = [FRCityModel mj_objectWithKeyValues:dict];
                    [cityList addObject:model];
                    if (model.isdefault == 1) {
                        [UserManager shareManager].city = model;
                    }
                }
                
                [FRManager shareManager].cityList = cityList;
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

@end

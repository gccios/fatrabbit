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
#import "FRMyInvoiceModel.h"
#import "FRStoreModel.h"

extern NSString * const FRUserLoginStatusDidChange; //用户退出通知
extern NSString * const FRUserStoreCartStatusDidChange; //用户购物车发生改变通知

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
@property (nonatomic, copy) NSString * vip_name;//VIP等级
@property (nonatomic, assign) CGFloat vip_discount;//VIP打折率
@property (nonatomic, copy) NSString * vip_discount_tip;//VIP打折率语义化结果

@property (nonatomic, strong) FRCityModel * city;//当前城市

@property (nonatomic, strong) NSMutableArray * addressList;//地址列表
@property (nonatomic, strong) NSMutableArray * invoiceList;//发票列表

@property (nonatomic, strong) NSMutableArray * storeCart;//购物车


- (void)loginSuccesWithCache:(NSDictionary *)data;

- (void)loginSuccessWithUid:(NSInteger)uid token:(NSString *)token mobile:(NSString *)mobile;

- (void)needUpdateLocalUserInfo;

/**
 添加商品到购物车

 @param model 要添加的商品规格model
 */
- (void)addStoreCartWithStore:(FRStoreSpecModel *)model;

/**
 移除商品从购物车
 
 @param model 移除的商品规格model
 */
- (void)removeStoreCartWithStore:(FRStoreSpecModel *)model;

- (void)requestStoreCartList;
- (void)requestAddressList;
- (void)requestInvoiceList;

@end

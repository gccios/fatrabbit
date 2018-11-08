//
//  UserManager.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "UserManager.h"
#import "FRStoreCartRequest.h"
#import "FRUserInvoiceRequest.h"
#import "FRUserAddressRequest.h"
#import "FRStoreCartModel.h"
#import "MBProgressHUD+FRHUD.h"

NSString * const FRUserLoginStatusDidChange = @"FRUserLoginStatusDidChange";
NSString * const FRUserStoreCartStatusDidChange = @"FRUserStoreCartStatusDidChange";
NSString * const DDUserDidGetWeChatCodeNotification = @"DDUserDidGetWeChatCodeNotification";
NSString * const DDUserWeChatPayNotification = @"DDUserWeChatPayNotification";
NSString * const DDUserAlipayPayNotification = @"DDUserAlipayPayNotification";

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

- (void)loginWithWeChat
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"com.fatrabbit.appstore";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DDUserDidGetWeChatCodeNotification object:resp];
        }else {
            
        }
    }else if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*) resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:DDUserWeChatPayNotification object:response];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:DDUserWeChatPayNotification object:response];
                break;
        }
    }
}

- (void)loginSuccesWithCache:(NSDictionary *)data
{
    [self mj_setKeyValues:data];
    self.isLogin = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:FRUserLoginStatusDidChange object:nil];
    [self configUserStoreInfo];
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
    [self configUserStoreInfo];
}

- (void)logOut
{
    self.isLogin = NO;
    self.uid = 0;
    self.token = @"";
    
    [[NSFileManager defaultManager] removeItemAtPath:FRUserInfoPath error:nil];
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

- (void)addStoreCartWithStore:(FRStoreSpecModel *)model
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initAddWithStoreID:model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD showTextHUDWithText:@"添加成功"];
        [self requestStoreCartList];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        
    }];
}

- (void)removeStoreCartWithStore:(FRStoreSpecModel *)model
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initDeleteWithStoreID:model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self requestStoreCartList];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        
    }];
}

- (void)configUserStoreInfo
{
    [self requestAddressList];
    [self requestInvoiceList];
    [self requestStoreCartList];
}

- (void)requestAddressList
{
    FRUserAddressRequest * request = [[FRUserAddressRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                self.addressList = [FRAddressModel mj_objectArrayWithKeyValuesArray:data];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)requestInvoiceList
{
    FRUserInvoiceRequest * request = [[FRUserInvoiceRequest alloc] initWithGetList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                self.invoiceList = [FRMyInvoiceModel mj_objectArrayWithKeyValuesArray:data];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)requestStoreCartList
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initWithStoreList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                NSArray * list = [data objectForKey:@"list"];
                if (KIsArray(list)) {
                    self.storeCart = [FRStoreCartModel mj_objectArrayWithKeyValuesArray:list];
                    [[NSNotificationCenter defaultCenter] postNotificationName:FRUserStoreCartStatusDidChange object:nil];
                }
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (NSMutableArray *)addressList
{
    if (!_addressList) {
        _addressList = [[NSMutableArray alloc] init];
    }
    return _addressList;
}

- (NSMutableArray *)storeCart
{
    if (!_storeCart) {
        _storeCart = [[NSMutableArray alloc] init];
    }
    return _storeCart;
}

@end

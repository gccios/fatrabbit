//
//  AppDelegate.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "AppDelegate.h"
#import "FRTabBarController.h"
#import "FatrabbitConfig.h"
#import "UserManager.h"
#import "SplashViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "FRPushRequest.h"
#import "GCCKeyChain.h"
#import "MBProgressHUD+FRHUD.h"
#import "FROrderRequest.h"
#import "FROrderDetailViewController.h"
#import "FRNeedDetailViewController.h"

// 引入 JPush 功能所需头文件
#import <JPUSHService.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <SplashViewControllerDelegate, JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:1.f];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [FatrabbitConfig configFatrabbitApplication];
    
    BOOL temp = [FRUserDefaultsGet(HasLaunched) boolValue];
    if (temp) {
        [self createRootViewController];
    }else{
        [self gotoGuidePageView];
    }
    
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:@"App Store"
                 apsForProduction:1];
    
    //清空推送角标数量
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

-(void)gotoGuidePageView
{
    SplashViewController* splashViewController = [[SplashViewController alloc]init];
    splashViewController.delegate = self;
    self.window.rootViewController = splashViewController;
    [self.window makeKeyAndVisible];
}

#pragma mark splashViewControllerDelegate

-(void)splashViewControllerSureBtnClicked{
    
    FRUserDefaultsSet(HasLaunched, @(YES));
    [self createRootViewController];
}

- (void)createRootViewController
{
    FRTabBarController * tabBar = [[FRTabBarController alloc] init];
    self.window.rootViewController = tabBar;
    
    [self.window makeKeyAndVisible];
}

#pragma mark - 推送相关
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    //上传极光ID
    NSString * jPushID = [JPUSHService registrationID];
    [GCCKeyChain save:JPushIDKeychainID data:jPushID];
    
    if (!isEmptyString(jPushID)) {
        FRPushRequest * request = [[FRPushRequest alloc] initJPushReportWithID:jPushID];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [WXApi handleOpenURL:url delegate:[UserManager shareManager]];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                [self alipayCallBackWith:resultDic];
            }];
        }
    }
    return result;
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self showNotificationWithDict:userInfo];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self showNotificationWithDict:userInfo];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [self showNotificationWithDict:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)showNotificationWithDict:(NSDictionary *)dict
{
    UIViewController * tab = self.window.rootViewController;
    if ([tab isKindOfClass:[UITabBarController class]]) {
        if (KIsDictionary(dict)) {
            NSInteger cid = [[dict objectForKey:@"id"] integerValue];
            NSInteger type = [[dict objectForKey:@"type"] integerValue];
            if (type == 1) {
                [self showStoreWithOrderID:cid];
            }else if (type == 2) {
                [self showServiceDetailWithOrderID:cid];
            }else if (type == 3){
                [self showNeedDetailWithID:cid];
            }
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (KIsDictionary(dict)) {
                NSInteger cid = [[dict objectForKey:@"id"] integerValue];
                NSInteger type = [[dict objectForKey:@"type"] integerValue];
                if (type == 1) {
                    [self showStoreWithOrderID:cid];
                }else if (type == 2) {
                    [self showServiceDetailWithOrderID:cid];
                }else if (type == 3){
                    [self showNeedDetailWithID:cid];
                }
            }
        });
    }
}

- (void)showServiceDetailWithOrderID:(NSInteger)orderID
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:[UIApplication sharedApplication].keyWindow];
    FROrderRequest * request = [[FROrderRequest alloc] initServiceDetailWithID:orderID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSDictionary * data = [response objectForKey:@"data"];
        FRMyServiceOrderModel * serviceModel = [FRMyServiceOrderModel mj_objectWithKeyValues:data];
        serviceModel.cid = orderID;
        FROrderDetailViewController * detail = [[FROrderDetailViewController alloc] initWithServiceModel:serviceModel];
        
        UITabBarController * tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController * na = tab.selectedViewController;
        [na pushViewController:detail animated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        
    }];
}

- (void)showStoreWithOrderID:(NSInteger)orderID
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:[UIApplication sharedApplication].keyWindow];
    FROrderRequest * request = [[FROrderRequest alloc] initStoreDetailWithID:orderID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSDictionary * data = [response objectForKey:@"data"];
        FRMyStoreOrderModel * storeModel = [FRMyStoreOrderModel mj_objectWithKeyValues:data];
        storeModel.cid = orderID;
        FROrderDetailViewController * detail = [[FROrderDetailViewController alloc] initWithStoreModel:storeModel];
        
        UITabBarController * tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController * na = tab.selectedViewController;
        [na pushViewController:detail animated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        
    }];
}

- (void)showNeedDetailWithID:(NSInteger)needID
{
    FRNeedModel * model = [[FRNeedModel alloc] init];
    model.cid = needID;
    FRNeedDetailViewController * detail = [[FRNeedDetailViewController alloc] initWithNeedModel:model];
    UITabBarController * tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController * na = tab.selectedViewController;
    [na pushViewController:detail animated:YES];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [WXApi handleOpenURL:url delegate:[UserManager shareManager]];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                [self alipayCallBackWith:resultDic];
            }];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [WXApi handleOpenURL:url delegate:[UserManager shareManager]];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                [self alipayCallBackWith:resultDic];
            }];
        }
    }
    return result;
}

- (void)alipayCallBackWith:(NSDictionary *)result
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DDUserAlipayPayNotification object:result];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

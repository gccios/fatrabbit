//
//  FatrabbitConfig.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FatrabbitConfig.h"
#import <IQKeyboardManager.h>
#import "GCCKeyChain.h"

@implementation FatrabbitConfig

//配置fatrabbit基础项
+ (void)configFatrabbitApplication
{
    //利用keyChain存储，仿造设备唯一标识
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (![GCCKeyChain load:keychainID]) {
        [GCCKeyChain save:keychainID data:identifierNumber];
    }
    
    //第三方键盘管理设置
    IQKeyboardManager * keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
}

@end

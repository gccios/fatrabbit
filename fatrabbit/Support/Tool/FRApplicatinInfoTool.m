//
//  FRApplicatinInfoTool.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRApplicatinInfoTool.h"
#import <sys/utsname.h>
#import "MBProgressHUD+FRHUD.h"

@implementation FRApplicatinInfoTool

+ (NSString *)getTimeStampMS
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *)getApplicationVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getDeviceSystemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary * deviceDict = @{
                                  //iPhone
                                  @"iPhone1,1":@"iPhone 1G",
                                  @"iPhone1,2":@"iPhone 3G",
                                  @"iPhone2,1":@"iPhone 3GS",
                                  @"iPhone3,1":@"iPhone 4",
                                  @"iPhone3,2":@"Verizon iPhone 4",
                                  @"iPhone4,1":@"iPhone 4S",
                                  @"iPhone5,1":@"iPhone 5",
                                  @"iPhone5,2":@"iPhone 5",
                                  @"iPhone5,3":@"iPhone 5C",
                                  @"iPhone5,4":@"iPhone 5C",
                                  @"iPhone6,1":@"iPhone 5S",
                                  @"iPhone6,2":@"iPhone 5S",
                                  @"iPhone7,1":@"iPhone 6 Plus",
                                  @"iPhone7,2":@"iPhone 6",
                                  @"iPhone8,1":@"iPhone 6s",
                                  @"iPhone8,2":@"iPhone 6s Plus",
                                  @"iPhone9,1":@"iPhone 7",
                                  @"iPhone9,3":@"iPhone 7",
                                  @"iPhone9,2":@"iPhone 7 Plus",
                                  @"iPhone9,4":@"iPhone 7 Plus",
                                  @"iPhone10,1":@"iPhone 8",
                                  @"iPhone10,4":@"iPhone 8",
                                  @"iPhone10,2":@"iPhone 8 Plus",
                                  @"iPhone10,5":@"iPhone 8 Plus",
                                  @"iPhone10,3":@"iPhone X",
                                  @"iPhone10,6":@"iPhone X",
                                  
                                  //iPod
                                  @"iPod1,1":@"iPod Touch 1",
                                  @"iPod2,1":@"iPod Touch 2",
                                  @"iPod3,1":@"iPod Touch 3",
                                  @"iPod4,1":@"iPod Touch 4",
                                  @"iPod5,1":@"iPod Touch 5",
                                  @"iPod7,1":@"iPod Touch 6",
                                  
                                  //iPad
                                  @"iPad1,1":@"iPad",
                                  @"iPad2,1":@"iPad 2 (WiFi)",
                                  @"iPad2,2":@"iPad 2 (GSM)",
                                  @"iPad2,3":@"iPad 2 (CDMA)",
                                  @"iPad2,4":@"iPad 2 (32nm)",
                                  @"iPad2,5":@"iPad mini (WiFi)",
                                  @"iPad2,6":@"iPad mini (GSM)",
                                  @"iPad2,7":@"iPad mini (CDMA)",
                                  
                                  @"iPad3,1":@"iPad 3(WiFi)",
                                  @"iPad3,2":@"iPad 3(CDMA)",
                                  @"iPad3,3":@"iPad 3(4G)",
                                  @"iPad3,4":@"iPad 4 (WiFi)",
                                  @"iPad3,5":@"iPad 4 (4G)",
                                  @"iPad3,6":@"iPad 4 (CDMA)",
                                  
                                  @"iPad4,1":@"iPad Air",
                                  @"iPad4,2":@"iPad Air",
                                  @"iPad4,3":@"iPad Air",
                                  @"iPad5,3":@"iPad Air 2",
                                  @"iPad5,4":@"iPad Air 2",
                                  
                                  @"iPad4,4":@"iPad mini 2",
                                  @"iPad4,5":@"iPad mini 2",
                                  @"iPad4,6":@"iPad mini 2",
                                  @"iPad4,7":@"iPad mini 3",
                                  @"iPad4,8":@"iPad mini 3",
                                  @"iPad4,9":@"iPad mini 3",
                                  @"iPad5,1":@"iPad mini 4",
                                  @"iPad5,2":@"iPad mini 4",
                                  
                                  @"iPad6,3":@"iPad Pro (9.7-inch)",
                                  @"iPad6,4":@"iPad Pro (9.7-inch)",
                                  @"iPad6,7":@"iPad Pro (12.9-inch)",
                                  @"iPad6,8":@"iPad Pro (12.9-inch)",
                                  @"iPad6,11":@"iPad 5",
                                  @"iPad6,12":@"iPad 5",
                                  @"iPad7,1" :@"iPad Pro 2 (12.9-inch)",
                                  @"iPad7,2" :@"iPad Pro 2 (12.9-inch)",
                                  @"iPad7,3" :@"iPad Pro (10.5-inch)",
                                  @"iPad7,4" :@"iPad Pro (10.5-inch)",
                                  
                                  //模拟器
                                  @"i386"   :@"Simulator",
                                  @"x86_64": @"Simulator"
                                  };
    
    NSString * deviceName = [deviceDict objectForKey:deviceString];
    if (isEmptyString(deviceName)) {
        return deviceString;
    }
    
    return deviceName;
}

#pragma mark -- 获取当前系统的缓存大小
+ (NSString *)getApplicationCache
{
    long long folderSize = 0;
    
    folderSize += [[SDImageCache sharedImageCache] getSize];
    
    if (folderSize > 1024 * 100) {
        return [NSString stringWithFormat:@"%.2lf M", folderSize/(1024.0*1024.0)];
    }else if(folderSize > 1024){
        return [NSString stringWithFormat:@"%.2lf KB", folderSize/1024.0];
    }else if (folderSize < 10){
        return [NSString stringWithFormat:@"%lld B", folderSize];
    }
    return [NSString stringWithFormat:@"%.2lld B", folderSize];
}

+ (void)clearApplicationCache:(SDWebImageNoParamsBlock)completion
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在清理..." inView:[UIApplication sharedApplication].keyWindow];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"清理完成"];
        completion();
    }];
}

@end

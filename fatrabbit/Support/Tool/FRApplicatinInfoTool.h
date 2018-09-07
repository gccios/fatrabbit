//
//  FRApplicatinInfoTool.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDImageCache.h>

/**
 获取APP相关信息以及操作缓存类
 */
@interface FRApplicatinInfoTool : NSObject

+ (NSString *)getApplicationVersion;

+ (NSString *)getDeviceSystemVersion;

+ (NSString *)getDeviceModel;

+ (NSString *)getApplicationCache;

+ (void)clearApplicationCache:(nullable SDWebImageNoParamsBlock)completion;

@end

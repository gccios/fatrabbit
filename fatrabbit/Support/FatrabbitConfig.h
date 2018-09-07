//
//  FatrabbitConfig.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 对项目整体进行配置的类
*/
@interface FatrabbitConfig : NSObject

//本地配置基本信息
+ (void)configFatrabbitApplication;

//网络请求获取基础配置信息
+ (void)configFatrabbitApplicationWithNetworkData;

+ (void)requestFatrabbitCateInfo;

+ (void)requestFatrabbitCityInfo;

@end

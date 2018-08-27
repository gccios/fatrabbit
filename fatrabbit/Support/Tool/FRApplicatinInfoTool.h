//
//  FRApplicatinInfoTool.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRApplicatinInfoTool : NSObject

+ (NSString *)getApplicationVersion;

+ (NSString *)getDeviceSystemVersion;

+ (NSString *)getDeviceModel;

@end

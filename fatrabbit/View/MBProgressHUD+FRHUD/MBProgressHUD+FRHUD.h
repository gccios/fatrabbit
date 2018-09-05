//
//  MBProgressHUD+FRHUD.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (FRHUD)

+ (MBProgressHUD *)showLoadingHUDWithText:(NSString *)text inView:(UIView *)view;

+ (void)showTextHUDWithText:(NSString *)text;

@end

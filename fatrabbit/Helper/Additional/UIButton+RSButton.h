//
//  UIButton+RSButton.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RSButtonTypeRight = 0,
    RSButtonTypeLeft,
    RSButtonTypeBottom,
    RSButtonTypeTop
} RSButtonType;

@interface UIButton (RSButton)

/**
 
 *  设置button中title的位置
 
 * *@paramtype type位置类型
 
 */

- (void)setButtonShowType:(RSButtonType)type;

@end

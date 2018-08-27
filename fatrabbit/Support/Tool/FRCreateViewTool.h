//
//  FRCreateViewTool.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 该工厂类用于创建View
 */
@interface FRCreateViewTool : NSObject

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment;

+ (UIButton *)createButtonWithFrame:(CGRect)frame font:(UIFont *)font titleColor:(UIColor *)titleColor title:(NSString *)title;

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame contentModel:(UIViewContentMode)model image:(UIImage *)image;

+ (void)cornerView:(UIView *)view radius:(CGFloat)radius;

@end

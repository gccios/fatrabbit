//
//  UIButton+RSButton.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "UIButton+RSButton.h"

@implementation UIButton (RSButton)

- (void)setButtonShowType:(RSButtonType)type
{
    [self layoutIfNeeded];
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    CGFloat space = titleFrame.origin.x- imageFrame.origin.x- imageFrame.size.width+4;
    
    switch (type) {
            
        case RSButtonTypeRight:
        {
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0,imageFrame.size.width- space,0, -(imageFrame.size.width- space))];[self setImageEdgeInsets:UIEdgeInsetsMake(0, -(titleFrame.origin.x- imageFrame.origin.x),0, imageFrame.origin.x- titleFrame.origin.x)];
            
        }
        break;
            
        case RSButtonTypeLeft:
        {
            
            [self setImageEdgeInsets:UIEdgeInsetsMake(0,titleFrame.size.width+ space,0, -(titleFrame.size.width+ space))];[self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(titleFrame.origin.x- imageFrame.origin.x),0, titleFrame.origin.x- imageFrame.origin.x)];
            
        }
        break;
            
        case RSButtonTypeBottom:
        {
            
            [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleFrame.size.height+ space, -(titleFrame.size.width))];[self setTitleEdgeInsets:UIEdgeInsetsMake(imageFrame.size.height+ space, -(imageFrame.size.width),0,0)];
            
        }
        break;
        
        case RSButtonTypeTop:
        {
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0,-(imageFrame.size.width), imageFrame.size.height+ space,0)];[self setImageEdgeInsets:UIEdgeInsetsMake(titleFrame.size.height+ space,(titleFrame.size.width),0,0)];
            
        }
        break;
            
        default:
            
        break;
    }
    
}

@end

//
//  LookImageViewController.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 全屏查看单图页面
 */
@interface LookImageViewController : UIViewController

- (instancetype)initWithImageURL:(NSString *)imageURL;

- (instancetype)initWithImage:(UIImage *)image;

@end

//
//  FRCatePageViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "WMPageController.h"
#import "FRManager.h"

/**
 分类页，继承WMPageController实现多控制器翻页
 */
@interface FRCatePageViewController : WMPageController

- (instancetype)initWithModel:(FRCateModel *)model;

@end

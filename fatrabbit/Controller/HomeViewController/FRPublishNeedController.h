//
//  FRPublishNeedController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRCateModel.h"
#import "FRNeedModel.h"

extern NSString * const FRNeedDidPublishNotification; //需求发布通知

/**
 发布需求页面
 */
@interface FRPublishNeedController : FRBaseViewController

- (instancetype)initWithFRCateModel:(FRCateModel *)model;

- (instancetype)initEditWithNeedModel:(FRNeedModel *)needModel imageSource:(NSArray *)imageSource cateModel:(FRCateModel *)model;

@end

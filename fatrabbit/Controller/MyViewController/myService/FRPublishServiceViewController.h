//
//  FRPublishServiceViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRMySeriviceModel.h"
#import "FRCateModel.h"

@protocol FRPublishServiceViewControllerDelegate <NSObject>

- (void)FRPublishServiceDidUpdate;

@end

/**
 发布服务页面
 */
@interface FRPublishServiceViewController : FRBaseViewController

@property (nonatomic, weak) id<FRPublishServiceViewControllerDelegate> delegate;

- (instancetype)initWithFRCateModel:(FRCateModel *)model;

- (instancetype)initEditWithServiceModel:(FRMySeriviceModel *)seriviceModel imageSource:(NSArray *)imageSource cateModel:(FRCateModel *)model;

@end

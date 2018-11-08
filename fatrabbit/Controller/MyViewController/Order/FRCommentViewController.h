//
//  FRCommentViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRMyStoreOrderModel.h"
#import "FRMyServiceOrderModel.h"

@protocol FRCommentViewControllerDelegate <NSObject>

- (void)conmentDidCompelete;

@end

/**
 评论页面
 */
@interface FRCommentViewController : FRBaseViewController

@property (nonatomic, weak) id<FRCommentViewControllerDelegate> delegate;

- (instancetype)initWithStoreModel:(FRMyStoreOrderModel *)model;

- (instancetype)initWithSeriviceModel:(FRMyServiceOrderModel *)model;

@end

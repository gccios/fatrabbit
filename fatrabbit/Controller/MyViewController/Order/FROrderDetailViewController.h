//
//  FROrderDetailViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRMyStoreOrderModel.h"
#import "FRMyServiceOrderModel.h"

@protocol FROrderDetailViewControllerDelegate <NSObject>

- (void)orderDidNeedUpdate;

@end

/**
 订单详情页面
 */
@interface FROrderDetailViewController : FRBaseViewController

@property (nonatomic, assign) BOOL needPopSecond;
@property (nonatomic, weak) id<FROrderDetailViewControllerDelegate> delegate;

- (instancetype)initWithStoreModel:(FRMyStoreOrderModel *)model;

- (instancetype)initWithServiceModel:(FRMyServiceOrderModel *)model;

@property (nonatomic, assign) BOOL isMyGet;

@end

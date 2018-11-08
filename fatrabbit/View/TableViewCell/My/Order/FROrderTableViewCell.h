//
//  FROrderTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMyStoreOrderModel.h"

@interface FROrderTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^leftHandle)(FRMyStoreOrderModel *orderModel);

@property (nonatomic, copy) void (^rightHandle)(FRMyStoreOrderModel *orderModel);

- (void)configWthModel:(FRMyStoreOrderModel *)model;

@end

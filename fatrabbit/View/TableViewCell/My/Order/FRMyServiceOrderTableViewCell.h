//
//  FRMyServiceOrderTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMyServiceOrderModel.h"

@interface FRMyServiceOrderTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^leftHandle)(FRMyServiceOrderModel *orderModel);

@property (nonatomic, copy) void (^rightHandle)(FRMyServiceOrderModel *orderModel);

- (void)configWithModel:(FRMyServiceOrderModel *)model;

@end

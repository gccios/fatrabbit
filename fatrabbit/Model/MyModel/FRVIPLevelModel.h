//
//  FRVIPLevelModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

/**
 VIP等级model
 */
@interface FRVIPLevelModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger expense_min_amount;
@property (nonatomic, assign) NSInteger expense_max_amount;
@property (nonatomic, copy) NSString * expense_amount_tip;
@property (nonatomic, assign) NSInteger discount;
@property (nonatomic, copy) NSString * discount_tip;

@end

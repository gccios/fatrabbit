//
//  FRMyAccountMoneyModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/25.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>

/**
 我的账户余额model
 */
@interface FRMyAccountMoneyModel : NSObject

@property (nonatomic, copy) NSString * remark;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, copy) NSString * addtime;

@end

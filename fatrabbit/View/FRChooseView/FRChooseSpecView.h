//
//  FRChooseSpecView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRChooseSpecCell.h"

/**
 选择商品规格的View类
 */
@interface FRChooseSpecView : UIView

@property (nonatomic, copy) void (^chooseDidCompletetHandle)(FRStoreSpecModel *model);

- (instancetype)initWithSpecList:(NSArray *)specList chooseModel:(FRStoreSpecModel *)model;

- (void)show;

@end

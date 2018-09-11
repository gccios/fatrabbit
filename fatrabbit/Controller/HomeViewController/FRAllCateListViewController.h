//
//  FRAllCateListViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRManager.h"

@protocol FRAllCateListViewControllerDelegate <NSObject>

- (void)FRAllCateListViewControllerDidChoose:(FRCateModel *)model;

@end

@interface FRAllCateListViewController : FRBaseViewController

@property (nonatomic, weak) id<FRAllCateListViewControllerDelegate> delegate;

@end

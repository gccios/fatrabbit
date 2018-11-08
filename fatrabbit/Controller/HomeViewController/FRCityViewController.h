//
//  FRCityViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRManager.h"

@protocol FRCityViewControllerDelegate <NSObject>

- (void)FRCityViewControllerDidChoose:(FRCityModel *)model;

@end

/**
 城市选择页面
 */
@interface FRCityViewController : FRBaseViewController

- (instancetype)initWithProvideChoose;

@property (nonatomic, weak) id<FRCityViewControllerDelegate> delegate;

@end

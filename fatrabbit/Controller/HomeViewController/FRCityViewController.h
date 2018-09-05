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

@interface FRCityViewController : FRBaseViewController

@property (nonatomic, weak) id<FRCityViewControllerDelegate> delegate;

@end

//
//  FRUserHeaderView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMyMenuCollectionViewCell.h"

@interface FRUserHeaderView : UIView

@property (nonatomic, copy) void (^userInfoDidClickedHandle)(void);

@property (nonatomic, copy) void (^userHeaderMenuDidClickedHandle)(FRUserHeaderMenuModel *model);

- (void)userLoginStatusChange;

@end

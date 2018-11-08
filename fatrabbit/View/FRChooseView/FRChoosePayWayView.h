//
//  FRChoosePayWayView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPayWayModel.h"

@interface FRChoosePayWayView : UIView

@property (nonatomic, copy) void (^chooseDidCompletetHandle)(FRPayWayModel *model);

- (instancetype)initWithModel:(FRPayWayModel *)model;

- (instancetype)initServiceChooseWithModel:(FRPayWayModel *)model;

- (void)show;

@end

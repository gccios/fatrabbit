//
//  FRCommentLevelView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJGradeStarsControl.h"

/**
 该类用于用户评论分数的操作和展示
 */
@interface FRCommentLevelView : UIView

@property (nonatomic, strong) LMJGradeStarsControl * serviceLevel;//服务评分
@property (nonatomic, strong) LMJGradeStarsControl * companyLevel;//公司评分
@property (nonatomic, strong) LMJGradeStarsControl * businessLevel;//业务评分

- (instancetype)initWithCommentNormal;

- (void)showWithServiceLevel:(NSInteger)serviceLevel companyLevel:(NSInteger)companyLevel businessLevel:(NSInteger)businessLevel;

- (void)configDelegateWith:(id)delegate;

@end

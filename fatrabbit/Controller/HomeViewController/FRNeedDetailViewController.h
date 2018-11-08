//
//  FRNeedDetailViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRNeedModel.h"

/**
 需求详情页面
 */
@interface FRNeedDetailViewController : FRBaseViewController

- (instancetype)initWithNeedModel:(FRNeedModel *)model;

@end

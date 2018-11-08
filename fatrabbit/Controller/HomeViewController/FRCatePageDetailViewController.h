//
//  FRCatePageDetailViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRCateModel.h"

/**
 分类页，展示某一分类下的需求和服务信息
 */
@interface FRCatePageDetailViewController : FRBaseViewController

- (instancetype)initWithCateModel:(FRCateModel *)model;

@end

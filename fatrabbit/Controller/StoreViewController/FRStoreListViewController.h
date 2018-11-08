//
//  FRStoreListViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRCateModel.h"

/**
 商品列表页面
 */
@interface FRStoreListViewController : FRBaseViewController

- (void)configWithModel:(FRCateModel *)model;

- (void)searchWithKeyWord:(NSString *)keyWord;

- (void)search;

@end

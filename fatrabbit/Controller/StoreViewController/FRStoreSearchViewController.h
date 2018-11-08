//
//  FRStoreSearchViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRCateModel.h"
#import "FRStoreBlockModel.h"

typedef enum : NSUInteger {
    FRStoreSearchType_Cate,
    FRStoreSearchType_Deal,
    FRStoreSearchType_Price
} FRStoreSearchType;

/**
 商品搜索页面
 */
@interface FRStoreSearchViewController : FRBaseViewController

- (instancetype)initWithCateModel:(FRCateModel *)model cateList:(NSArray *)cateList;

- (instancetype)initWithStoreBlockModel:(FRStoreBlockModel *)model cateList:(NSArray *)cateList;

@end

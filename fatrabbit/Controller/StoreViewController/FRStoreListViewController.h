//
//  FRStoreListViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRCateModel.h"

typedef enum : NSUInteger {
    FRStoreSearchType_All,
    FRStoreSearchType_DealNumber,
    FRStoreSearchType_Price
} FRStoreSearchType;

@interface FRStoreListViewController : FRBaseViewController

- (instancetype)initWithType:(FRStoreSearchType)type;

- (void)configWithModel:(FRCateModel *)model;

- (void)searchWithKeyWord:(NSString *)keyWord;

- (void)search;

@end

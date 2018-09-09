//
//  FRStorePriceView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRStoreModel.h"

@interface FRStorePriceView : UIView

- (instancetype)initWithModel:(FRStoreModel *)model;

- (void)configWithSpecModel:(FRStoreSpecModel *)model;

@end

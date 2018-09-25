//
//  FRStoreOrderDetailCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRStoreCartModel.h"

@interface FRStoreOrderDetailCell : UICollectionViewCell

- (void)configWithModel:(FRStoreCartModel *)model;

@end

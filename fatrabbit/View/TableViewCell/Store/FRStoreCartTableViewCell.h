//
//  FRStoreCartTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRStoreModel.h"

@interface FRStoreCartTableViewCell : UITableViewCell

- (void)configWithGoodsModel:(FRStoreModel *)model;

@end

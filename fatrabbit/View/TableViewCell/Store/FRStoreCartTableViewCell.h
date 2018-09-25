//
//  FRStoreCartTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRStoreCartModel.h"

@interface FRStoreCartTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^addCartHandle)(FRStoreCartModel * cartModel);
@property (nonatomic, copy) void (^deleteCartHandle)(FRStoreCartModel * cartModel);
@property (nonatomic, copy) void (^chooseCartHandle)(FRStoreCartModel * cartModel);

- (void)configWithGoodsModel:(FRStoreCartModel *)model;

@end

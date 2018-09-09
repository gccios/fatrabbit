//
//  FRMenuCollectionViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCateModel.h"

@interface FRMenuCollectionViewCell : UICollectionViewCell

- (void)configLastHomeCate;

- (void)configLastStoreCate;

- (void)configWithCateModel:(FRCateModel *)model;

@end

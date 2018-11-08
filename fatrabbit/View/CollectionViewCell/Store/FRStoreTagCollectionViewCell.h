//
//  FRStoreTagCollectionViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/14.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRStoreTagModel.h"

@interface FRStoreTagCollectionViewCell : UICollectionViewCell

- (void)configWithHighLight:(BOOL)lighted;

- (void)configWithModel:(FRStoreTagModel *)model;

@end

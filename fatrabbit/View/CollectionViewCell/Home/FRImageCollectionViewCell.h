//
//  FRImageCollectionViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^imageDeleteHandle)(void);

- (void)configLastCell;

- (void)configWithImage:(UIImage *)image;

@end

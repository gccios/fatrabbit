//
//  FRTagCollectionHeaderView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRTagCollectionHeaderView : UICollectionReusableView

@property (nonatomic, copy) void (^moreDidClickedHandle)(void);

- (void)configWithTitle:(NSString *)title;

@end

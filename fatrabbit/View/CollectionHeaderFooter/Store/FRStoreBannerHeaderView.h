//
//  FRStoreBannerHeaderView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRStoreBannerHeaderView : UICollectionReusableView

- (void)configWithBannerSource:(NSMutableArray *)bannerSource;

- (void)configCateSource:(NSMutableArray *)cateSource;

@end

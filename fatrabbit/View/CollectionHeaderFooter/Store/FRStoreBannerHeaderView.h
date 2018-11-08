//
//  FRStoreBannerHeaderView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCateModel.h"
#import <SDCycleScrollView.h>

@interface FRStoreBannerHeaderView : UICollectionReusableView

@property (nonatomic, strong) SDCycleScrollView * bannerView;

@property (nonatomic, copy) void (^moreDidClickedHandle)(void);
@property (nonatomic, copy) void (^menuDidClickedHandle)(FRCateModel *model);

- (void)configWithTitle:(NSString *)title;

- (void)configWithBannerSource:(NSMutableArray *)bannerSource;

- (void)configCateSource:(NSMutableArray *)cateSource;

@end

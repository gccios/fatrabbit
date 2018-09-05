//
//  FRCateListViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRManager.h"

typedef enum : NSUInteger {
    FRCateListType_Publish,
    FRCateListType_Watch,
    FRCateListType_Choose
} FRCateListType;

@protocol FRCateListViewControllerDelegate <NSObject>

- (void)FRcateListViewCongtrollerDidChoose:(FRCateModel *)model type:(FRCateListType)type;

@end

@interface FRCateListViewController : UIViewController

@property (nonatomic, weak) id<FRCateListViewControllerDelegate> delegate;

- (instancetype)initWithType:(FRCateListType)type;

@end

//
//  FRCateListViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FRCateListType_Publish,
    FRCateListType_Watch
} FRCateListType;

@interface FRCateListViewController : UIViewController

- (instancetype)initWithType:(FRCateListType)type;

@end

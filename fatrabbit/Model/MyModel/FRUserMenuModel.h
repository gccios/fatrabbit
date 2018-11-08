//
//  FRUserMenuModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRUserMenuModel.h"

typedef enum : NSUInteger {
    FRUserMenuType_Logo,
    FRUserMenuType_NickName,
    FRUserMenuType_Mobile,
} FRUserMenuType;

/**
 用户菜单model
 */
@interface FRUserMenuModel : NSObject

- (instancetype)initWithType:(FRUserMenuType)type;

@property (nonatomic, assign) FRUserMenuType type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIImage * image;

@end

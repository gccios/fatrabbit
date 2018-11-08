//
//  FREditNameViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"

@protocol FREditNameViewControllerDelegate <NSObject>

- (void)FRUserNickNameDidUpdate:(NSString *)nickName;

@end

/**
 编辑昵称页面
 */
@interface FREditNameViewController : FRBaseViewController

@property (nonatomic, weak) id<FREditNameViewControllerDelegate> delegate;

@end

//
//  FRAddressViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "UserManager.h"

@protocol FRAddressViewControllerDelegate <NSObject>

- (void)FRAddressDidChoose:(FRAddressModel *)address;

@end

@interface FRAddressViewController : FRBaseViewController

@property (nonatomic, weak) id<FRAddressViewControllerDelegate> delegate;

@end

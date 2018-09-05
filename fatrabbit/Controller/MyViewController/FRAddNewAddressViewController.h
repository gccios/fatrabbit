//
//  FRAddNewAddressViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRAddressModel.h"

@protocol FRAddNewAddressViewControllerDelegate <NSObject>

- (void)FRAddressDidChange;

@end

@interface FRAddNewAddressViewController : FRBaseViewController

@property (nonatomic, weak) id<FRAddNewAddressViewControllerDelegate> delegate;

- (instancetype)initWithEditModel:(FRAddressModel *)model;

@end

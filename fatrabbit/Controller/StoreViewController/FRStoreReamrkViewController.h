//
//  FRStoreReamrkViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"

@interface FRStoreReamrkViewController : FRBaseViewController

@property (nonatomic, copy) void (^remarkDidCompletetHandle)(NSString *remark);

@end

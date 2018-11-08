//
//  FRMyNeedTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRNeedModel.h"

@interface FRMyNeedTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^deleteHandle)(FRNeedModel *needModel);

@property (nonatomic, copy) void (^editHandle)(FRNeedModel *needModel);

- (void)configWithModel:(FRNeedModel *)model;

@end

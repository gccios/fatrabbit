//
//  FRAddressTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRAddressModel.h"

@interface FRAddressTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^addressEditHandle)(void);

- (void)configWithModel:(FRAddressModel *)model;

@end

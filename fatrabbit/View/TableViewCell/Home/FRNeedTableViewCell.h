//
//  FRNeedTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRNeedModel.h"

@interface FRNeedTableViewCell : UITableViewCell

- (void)configWithModel:(FRNeedModel *)model;

@end
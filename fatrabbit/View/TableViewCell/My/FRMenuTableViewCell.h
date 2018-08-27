//
//  FRMenuTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMenuModel.h"

@interface FRMenuTableViewCell : UITableViewCell

- (void)configWithModel:(MyMenuModel *)model;

@end

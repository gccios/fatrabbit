//
//  FRServicePayWayCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRServicePayWayModel.h"

@interface FRServicePayWayCell : UITableViewCell

- (void)configWithModel:(FRServicePayWayModel *)model;

- (void)configChoose:(BOOL)choose;

@end

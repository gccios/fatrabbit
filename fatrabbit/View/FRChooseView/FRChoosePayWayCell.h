//
//  FRChoosePayWayCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPayWayModel.h"

@interface FRChoosePayWayCell : UITableViewCell

- (void)configWithModel:(FRPayWayModel *)model withChoose:(BOOL)chooseEnable;

@end

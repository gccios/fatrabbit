//
//  FRMyAccountMoneyCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/25.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMyAccountMoneyModel.h"
#import "FRMyPointsModel.h"

@interface FRMyAccountMoneyCell : UITableViewCell

- (void)configWithMoneyModel:(FRMyAccountMoneyModel *)model;

- (void)configWithPointsModel:(FRMyPointsModel *)model;

@end

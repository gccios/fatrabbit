//
//  FRMyServiceTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMySeriviceModel.h"

@interface FRMyServiceTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^deleteHandle)(FRMySeriviceModel *seriviceModel);

@property (nonatomic, copy) void (^editHandle)(FRMySeriviceModel *seriviceModel);

- (void)configWithModel:(FRMySeriviceModel *)model;

@end

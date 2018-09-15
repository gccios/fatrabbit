//
//  FRChooseSpecCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRStoreSpecModel.h"

@interface FRChooseSpecCell : UITableViewCell

- (void)configWithModel:(FRStoreSpecModel *)model withChoose:(BOOL)chooseEnable;

@end

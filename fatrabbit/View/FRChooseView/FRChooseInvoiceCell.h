//
//  FRChooseInvoiceCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMyInvoiceModel.h"

@interface FRChooseInvoiceCell : UITableViewCell

- (void)configWithModel:(FRMyInvoiceModel *)model withChoose:(BOOL)chooseEnable;

@end

//
//  FRMyInvoiceTableViewCell.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRMyInvoiceTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^invoiceEditHandle)(void);

@property (nonatomic, copy) void (^invoiceDeleteHandle)(void);

@end

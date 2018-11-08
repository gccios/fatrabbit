//
//  FREditInvoiceViewController.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"
#import "FRMyInvoiceModel.h"

@protocol FREditInvoiceViewControllerDelegate <NSObject>

- (void)FRUserInvoiceDidChange;

@end

/**
 编辑发票页面
 */
@interface FREditInvoiceViewController : FRBaseViewController

@property (nonatomic, weak) id<FREditInvoiceViewControllerDelegate> delegate;

- (instancetype)initWithInvoiceModel:(FRMyInvoiceModel *)invoiceModel;

@end

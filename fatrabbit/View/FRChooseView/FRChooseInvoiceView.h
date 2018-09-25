//
//  FRChooseInvoiceView.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRMyInvoiceModel.h"

@interface FRChooseInvoiceView : UIView

@property (nonatomic, copy) void (^chooseDidCompletetHandle)(FRMyInvoiceModel *model);

- (instancetype)initWithModel:(FRMyInvoiceModel *)model;

- (void)show;

@end

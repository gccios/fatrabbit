//
//  FRMyInvoiceModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/16.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface FRMyInvoiceModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * company;
@property (nonatomic, copy) NSString * idnumber;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * bankname;
@property (nonatomic, copy) NSString * bankaccount;

@end

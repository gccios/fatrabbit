//
//  FRAddressModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 地址model
 */
@interface FRAddressModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * consignee;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * address;

@end

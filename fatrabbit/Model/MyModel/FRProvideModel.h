//
//  FRProvideModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 供应商信息model
 */
@interface FRProvideModel : NSObject

@property (nonatomic, assign) NSInteger status;//审核状态，1为待审核,2为已审核通过,3为已拒绝
@property (nonatomic, copy) NSString * audit_remark;
@property (nonatomic, copy) NSArray * imgs;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, assign) NSInteger cate_id;
@property (nonatomic, copy) NSString * cate_name;
@property (nonatomic, assign) NSInteger region_id;
@property (nonatomic, copy) NSString * region_name;
@property (nonatomic, copy) NSString * business_license;
@property (nonatomic, copy) NSString * name;

@end

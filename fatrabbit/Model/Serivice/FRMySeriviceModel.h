//
//  FRMySeriviceModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>
#import "FRExampleModel.h"

/**
 我的服务model
 */
@interface FRMySeriviceModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger uid;//服务商用户id
@property (nonatomic, copy) NSString * mobile;//服务商手机号
@property (nonatomic, assign) NSInteger status;//服务状态，1为正常，2为已取消
@property (nonatomic, copy) NSString * title;//标题
@property (nonatomic, assign) CGFloat amount;//单价
@property (nonatomic, copy) NSString * remark;//备注
@property (nonatomic, copy) NSString * cover;//封面
@property (nonatomic, assign) CGFloat score;//评分
@property (nonatomic, assign) NSInteger first_cate_id;//一级分类ID
@property (nonatomic, assign) NSInteger second_cate_id;//二级分类ID
@property (nonatomic, copy) NSString * second_cate_name;//二级分类名称
@property (nonatomic, strong) NSArray * img;//图片集合
@property (nonatomic, copy) NSString * tip;//浏览次数
@property (nonatomic, copy) NSString * timetip;//浏览时间
@property (nonatomic, assign) NSInteger collect_id;//收藏ID

@property (nonatomic, copy) NSString * provider_name;
@property (nonatomic, copy) NSString * provider_avatar;
@property (nonatomic, copy) NSString * provider_tip;
@property (nonatomic, strong) NSArray * case_list;

@end

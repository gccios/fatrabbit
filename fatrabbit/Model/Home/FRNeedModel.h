//
//  FRNeedModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>

/**
 需求model
 */
@interface FRNeedModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * title;//标题
@property (nonatomic, copy) NSString * cover;//封面
@property (nonatomic, copy) NSString * remark;//备注
@property (nonatomic, copy) NSString * tip;//浏览次数
@property (nonatomic, copy) NSString * timetip;//上次浏览时间
@property (nonatomic, assign) NSInteger collect_id;//收藏ID

//详情返回信息
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger first_cate_id;
@property (nonatomic, copy) NSString * first_cate_name;
@property (nonatomic, assign) NSInteger second_cate_id;
@property (nonatomic, copy) NSString * second_cate_name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray * img;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, assign) NSInteger contact_status;

@end

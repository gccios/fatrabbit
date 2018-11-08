//
//  FRMyServiceOrderModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>

/**
 我的服务订单model
 */
@interface FRMyServiceOrderModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) NSInteger status;//状态,1为正常,0已取消
@property (nonatomic, assign) NSInteger paystatus;//付款状态,0未付款,1为已付款,2为已退款
@property (nonatomic, assign) NSInteger appraise_status;//评价状态,0为待评价,1为已评价
@property (nonatomic, assign) NSInteger paytype;//支付类型,1为一口价,2为定金尾款,3货到付款线下支付
@property (nonatomic, assign) NSInteger type; //1为待付款，3为待评价，4为已完成，5为已取消
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, assign) NSInteger rest_paystatus;//尾款订单付款状态 ，0未付款,1为已付款,2为已退款
@property (nonatomic, copy) NSString * rest_paytime;//尾款订单付款时间，不是尾款订单或未付款则返回空串

@property (nonatomic, copy) NSString * sn;
@property (nonatomic, copy) NSString * addtime;
@property (nonatomic, assign) NSInteger paymethod;
@property (nonatomic, copy) NSString * paytime;
@property (nonatomic, copy) NSString * provider_name;

@end

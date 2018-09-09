//
//  FRStoreModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/7.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>
#import "FRStoreSpecModel.h"

@interface FRStoreModel : NSObject

@property (nonatomic, assign) NSInteger cid;//ID
@property (nonatomic, assign) CGFloat price;//价格
@property (nonatomic, copy) NSString * name;//名称
@property (nonatomic, copy) NSString * cover;//封面图

//detail 商品详细信息
@property (nonatomic, copy) NSString * subtitle;//副标题
@property (nonatomic, strong) NSArray * photo;//商品图片集合
@property (nonatomic, assign) NSInteger points;//购买所需积分
@property (nonatomic, assign) NSInteger comment_num;//评论数
@property (nonatomic, assign) NSInteger order_num;//成交数量
@property (nonatomic, assign) NSInteger has_collect;//是否收藏
@property (nonatomic, strong) NSArray * spec;//商品的规格集合

@property (nonatomic, assign) NSInteger number;//选中该商品的数量

@end

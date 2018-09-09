//
//  FRStoreSpecModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRStoreSpecModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * name;//规格名称
@property (nonatomic, assign) CGFloat price;//规格价格
@property (nonatomic, assign) NSInteger stock;//规格库存
@property (nonatomic, assign) NSInteger isdefault;//是否是默认规格

@end

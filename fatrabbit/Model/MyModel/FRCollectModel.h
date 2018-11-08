//
//  FRCollectModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

/**
 收藏model
 */
@interface FRCollectModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger type;//类型,1为收藏的商品，2为收藏的服务，3为收藏的需求
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * city;

@end

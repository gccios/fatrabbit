//
//  FRStoreBlockModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/7.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "FRStoreModel.h"

/**
 商品大板块model
 */
@interface FRStoreBlockModel : NSObject

@property (nonatomic, assign) NSInteger label_id;
@property (nonatomic, copy) NSString * label_title;
@property (nonatomic, strong) NSArray * list;

@end

//
//  FRStoreModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/7.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>

@interface FRStoreModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, assign) NSInteger number;

@end

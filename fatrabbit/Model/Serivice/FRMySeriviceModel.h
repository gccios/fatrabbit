//
//  FRMySeriviceModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>

@interface FRMySeriviceModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, assign) CGFloat score;

@end

//
//  FRExampleModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

/**
 我的案例model
 */
@interface FRExampleModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) NSInteger collect_id;//收藏ID

@end

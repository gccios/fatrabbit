//
//  FRMessageModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/10/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface FRMessageModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * tip;
@property (nonatomic, copy) NSString * addtime;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger target_id;

@end

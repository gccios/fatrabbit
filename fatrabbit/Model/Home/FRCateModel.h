//
//  FRCateModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface FRCateModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * intro;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger sortnum;
@property (nonatomic, strong) NSArray * child;

@end

//
//  FRUserModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface FRUserModel : NSObject

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * token;

@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, assign) NSInteger is_supplier;

@end

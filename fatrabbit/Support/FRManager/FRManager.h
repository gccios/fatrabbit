//
//  FRManager.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRUserModel.h"

@interface FRManager : NSObject

@property (nonatomic, strong) FRUserModel * user;

+ (instancetype)shareManager;

@end

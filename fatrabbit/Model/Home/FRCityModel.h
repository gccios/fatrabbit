//
//  FRCityModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface FRCityModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger isfull;
@property (nonatomic, assign) NSInteger isdefault;

@end

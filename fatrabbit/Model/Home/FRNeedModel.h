//
//  FRNeedModel.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface FRNeedModel : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString * title;//标题
@property (nonatomic, copy) NSString * cover;//封面
@property (nonatomic, copy) NSString * remark;//备注
@property (nonatomic, copy) NSString * pvtip;//浏览次数
@property (nonatomic, copy) NSString * timetip;//上次浏览时间

@end

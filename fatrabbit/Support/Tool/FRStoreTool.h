//
//  FRStoreTool.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRCartEditRequest.h"
#import "FRStoreModel.h"


/**
 商品操作类
 */
@interface FRStoreTool : NSObject

+ (void)addStoreCartWithModel:(FRStoreModel *_Nullable)model success:(BGSuccessCompletionBlock _Nullable)successCompletionBlock businessFailure:(BGBusinessFailureBlock _Nullable)businessFailureBlock networkFailure:(BGNetworkFailureBlock _Nullable)networkFailureBlock;

+ (void)deleteStoreCartWithModel:(FRStoreModel *_Nullable)model success:(BGSuccessCompletionBlock _Nullable)successCompletionBlock businessFailure:(BGBusinessFailureBlock _Nullable)businessFailureBlock networkFailure:(BGNetworkFailureBlock _Nullable)networkFailureBlock;

@end

//
//  FRStoreTool.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreTool.h"

@implementation FRStoreTool

 + (void)addStoreCartWithModel:(FRStoreModel *)model success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    NSInteger sid = model.pid;
    FRCartEditRequest * request = [[FRCartEditRequest alloc] initAddWithStoreID:sid];
    [request sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}

 + (void)deleteStoreCartWithModel:(FRStoreModel *)model success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    NSInteger sid = model.pid;
    FRCartEditRequest * request = [[FRCartEditRequest alloc] initDeleteWithStoreID:sid];
    [request sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}

@end

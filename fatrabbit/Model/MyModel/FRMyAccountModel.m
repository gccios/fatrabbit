//
//  FRMyAccountModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyAccountModel.h"
#import "UserManager.h"

@implementation FRMyAccountModel

- (instancetype)initWithType:(FRMyAccountType)type
{
    if (self = [super init]) {
        
        self.type = type;
        
        if (type == FRMyAccountType_Money) {
            self.title = @"账户";
            self.detail = [NSString stringWithFormat:@"%.2lf", [UserManager shareManager].balance];
        }else if (type == FRMyAccountType_Point) {
            self.title = @"积分";
            self.detail = [NSString stringWithFormat:@"%ld", [UserManager shareManager].points];
        }else if (type == FRMyAccountType_Invoice) {
            self.title = @"发票";
        }
        
    }
    return self;
}

@end

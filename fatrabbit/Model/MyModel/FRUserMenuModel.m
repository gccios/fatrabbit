//
//  FRUserMenuModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserMenuModel.h"

@implementation FRUserMenuModel

- (instancetype)initWithType:(FRUserMenuType)type
{
    if (self = [super init]) {
        self.type = type;
        
        if (self.type == FRUserMenuType_Logo) {
            self.title = @"头像";
        }else if (self.type == FRUserMenuType_NickName) {
            self.title = @"用户名";
        }else if (self.type == FRUserMenuType_Mobile) {
            self.title = @"手机号码";
        }
        
    }
    return self;
}

@end

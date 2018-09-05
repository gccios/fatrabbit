//
//  FRSettingModel.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRSettingModel.h"

@implementation FRSettingModel

- (instancetype)initWithType:(FRSettingType)type
{
    if (self = [super init]) {
        
        self.type = type;
        
        if (type == FRSettingType_Cache) {
            self.title = @"清除缓存";
            self.detail = [FRApplicatinInfoTool getApplicationCache];
        }else if (type == FRSettingType_Version) {
            self.title = @"当前版本";
            self.detail = [FRApplicatinInfoTool getApplicationVersion];
        }else if (type == FRSettingType_AboutUs) {
            self.title = @"关于我们";
        }
        
    }
    return self;
}

@end

//
//  FRBaseNetworkRequest.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseNetworkRequest.h"
#import "GCCKeyChain.h"
#import "FRApplicatinInfoTool.h"
#import <AFNetworkReachabilityManager.h>

@implementation FRBaseNetworkRequest

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString * deviceID = [GCCKeyChain load:keychainID];
        if (isEmptyString(deviceID)) {
            deviceID = @"";
        }
        
        NSString * network = @"4g";
        AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            network = @"4g";
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            network = @"wifi";
        }else{
            network = @"unknow";
        }
        
        NSDictionary * client = @{
                                  @"os" : @"2",
                                  @"osv" : [FRApplicatinInfoTool getDeviceSystemVersion],
                                  @"deviceid" : deviceID,
                                  @"brand" : [FRApplicatinInfoTool getDeviceModel],
                                  @"model" : [NSString stringWithFormat:@"%@ %@", [FRApplicatinInfoTool getDeviceModel], [FRApplicatinInfoTool getDeviceSystemVersion]],
                                  @"channel" : @"appstore",
                                  @"network" : network
                                  };
        
        [self setValue:client forParamKey:@"client"];
        
    }
    return self;
}

@end

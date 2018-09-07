//
//  FRNetWorkConfiguration.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRNetWorkConfiguration.h"
#import "BGUtilFunction.h"
#import "GCCKeyChain.h"
#import "FRApplicatinInfoTool.h"
#import <AFNetworkReachabilityManager.h>
#import "UserManager.h"

@implementation FRNetWorkConfiguration

- (NSDictionary *)requestCommonHTTPHeaderFields {
    
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
    
    NSInteger uid = [UserManager shareManager].uid;
    NSString * token = [UserManager shareManager].token;
    
    NSDictionary * dict = @{
                              @"os" : @"2",
                              @"osv" : [FRApplicatinInfoTool getDeviceSystemVersion],
                              @"deviceid" : deviceID,
                              @"brand" : [FRApplicatinInfoTool getDeviceModel],
                              @"model" : [NSString stringWithFormat:@"%@ %@", [FRApplicatinInfoTool getDeviceModel], [FRApplicatinInfoTool getDeviceSystemVersion]],
                              @"channel" : @"appstore",
                              @"network" : network
                              };
    NSMutableDictionary * client = [[NSMutableDictionary alloc] initWithDictionary:dict];
    if (uid) {
        [client setValue:@(uid) forKey:@"uid"];
    }
    if (!isEmptyString(token)) {
        [client setValue:token forKey:@"token"];
    }
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:client options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return @{
             @"Content-Type":@"application/json",
             @"client":jsonString
             };
}

- (NSDictionary *)requestHTTPHeaderFields:(BGNetworkRequest *)request {
    NSMutableDictionary *allHTTPHeaderFileds = [[self requestCommonHTTPHeaderFields] mutableCopy];
    [request.requestHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        allHTTPHeaderFileds[key] = obj;
    }];
    return allHTTPHeaderFileds;
}

-(NSString *)queryStringForURLWithRequest:(BGNetworkRequest *)request{
    
    switch (request.httpMethod) {
        case BGNetworkRequestHTTPGet: {
            NSString *paramString = BGQueryStringFromParamDictionary(request.parametersDic);
            return [NSString stringWithFormat:@"%@", paramString];
        }
        case BGNetworkRequestHTTPPost: {
            return nil;
        }
        default:
            break;
    }
}

-(NSString *)baseURLString {
    return HOSTURL;
}

- (BOOL)shouldBusinessSuccessWithResponseData:(NSDictionary *)responseData task:(NSURLSessionDataTask *)task request:(BGNetworkRequest *)request {
    
    NSInteger code = [[responseData objectForKey:@"code"] integerValue];
    
    if (code == 1) {
        return YES;
    }
    return NO;
}

@end

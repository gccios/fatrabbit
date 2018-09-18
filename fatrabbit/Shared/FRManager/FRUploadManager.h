//
//  FRUploadManager.h
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/15.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliyunOSSiOS/OSSService.h>

@interface FRUploadManager : NSObject

//上传图片
@property (nonatomic, copy) NSString * bucket;
@property (nonatomic, assign) NSInteger countdown;
@property (nonatomic, copy) NSString * cdndomain;
@property (nonatomic, copy) NSString * accessKeySecret;
@property (nonatomic, copy) NSString * accessKeyId;
@property (nonatomic, copy) NSString * endpoint;
@property (nonatomic, copy) NSString * securityToken;

+ (instancetype)shareManager;

- (void)updateUploadAccessInfo;

- (void)uploadImageArray:(NSArray<UIImage *> *)images progress:(OSSNetworkingUploadProgressBlock)progress success:(void (^)(NSString *path , NSInteger index))successBlock failure:(void (^)(NSError *error, NSInteger index))failureBlock;

@end

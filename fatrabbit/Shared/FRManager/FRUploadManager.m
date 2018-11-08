//
//  FRUploadManager.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/15.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUploadManager.h"
#import "FRApplicatinInfoTool.h"
#import "UserManager.h"

@interface FRUploadManager ()

@property (nonatomic, strong) OSSClient * client;

@end

@implementation FRUploadManager

+ (instancetype)shareManager
{
    static dispatch_once_t once;
    static FRUploadManager * instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)updateUploadAccessInfoWithSuccess:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    FRAliyunSTSRequest * request = [[FRAliyunSTSRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                self.bucket = [data objectForKey:@"bucket"];
                self.countdown = [[data objectForKey:@"countdown"] integerValue];
                self.cdndomain = [data objectForKey:@"cdndomain"];
                self.accessKeySecret = [data objectForKey:@"accessKeySecret"];
                self.accessKeyId = [data objectForKey:@"accessKeyId"];
                self.endpoint = [data objectForKey:@"endpoint"];
                self.securityToken = [data objectForKey:@"securityToken"];
                
                // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
                id<OSSCredentialProvider> credential =  [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.accessKeyId secretKeyId:self.accessKeySecret securityToken:self.securityToken];
                OSSClientConfiguration * conf = [OSSClientConfiguration new];
                conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
                
                NSString * endpoint = self.cdndomain;
                if (isEmptyString(endpoint)) {
                    endpoint = self.endpoint;
                    endpoint = [endpoint stringByReplacingOccurrencesOfString:@"pxt." withString:@""];
                }
                
                self.client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
                
                successCompletionBlock(request, response);
            }
        }
        
    } businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}

- (void)uploadImageArray:(NSArray<UIImage *> *)images progress:(OSSNetworkingUploadProgressBlock)progress success:(void (^)(NSString *, NSInteger))successBlock failure:(void (^)(NSError *, NSInteger))failureBlock
{
    
    [self updateUploadAccessInfoWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self uploadWithImages:images progress:progress success:successBlock failure:failureBlock];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self uploadWithImages:images progress:progress success:successBlock failure:failureBlock];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self uploadWithImages:images progress:progress success:successBlock failure:failureBlock];
        
    }];
    
}

- (void)uploadWithImages:(NSArray<UIImage *> *)images progress:(OSSNetworkingUploadProgressBlock)progress success:(void (^)(NSString *, NSInteger))successBlock failure:(void (^)(NSError *, NSInteger))failureBlock
{
    for (NSInteger i = 0; i < images.count; i++) {
        UIImage * image = [images objectAtIndex:i];
        NSString * path =[NSString stringWithFormat:@"user/resource/photo/%ld/%@%@.jpg", [UserManager shareManager].uid, [FRApplicatinInfoTool getTimeStampMS], [self randomLetterAndNumber]];
        [self uploadImage:image withPath:path progress:progress success:^(NSString *path) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(path, i);
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(error, i);
            });
            
        }];
    }
}

- (void)uploadImage:(UIImage *)image withPath:(NSString *)path progress:(OSSNetworkingUploadProgressBlock)progress success:(void (^)(NSString *path))successBlock failure:(void (^)(NSError *error))failureBlock
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = self.bucket;
    put.objectKey = path;
    
    NSData*  data = UIImageJPEGRepresentation(image, 1);
    float tempX = 0.9;
    NSInteger length = data.length;
    while (data.length > 500*1024) {
        data = UIImageJPEGRepresentation(image, tempX);
        tempX -= 0.1;
        if (data.length == length) {
            break;
        }
        length = data.length;
    }
    
    put.uploadingData = data;
    put.uploadProgress = progress;
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (task.error) {
            if (failureBlock) {
                failureBlock(task.error);
            }
        }else{
            if (successBlock) {
                
                NSString * url = self.cdndomain;
                if (isEmptyString(url)) {
                    url = self.endpoint;
                }
                NSString * imageURL = [NSString stringWithFormat:@"%@/%@", url, put.objectKey];
                successBlock(imageURL);
            }
        }
        return nil;
    }];
}

//返回8位大小写字母和数字
- (NSString *)randomLetterAndNumber{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = @"";
    for (int i = 0; i < 8; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

@end

//
//  WBUploadImgManager.m
//  ComradeUncle
//
//  Created by wenbin on 16/6/20.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "WBUploadImgManager.h"
@implementation WBUploadImgManager

+ (WBUploadImgManager *)shareClient
{
    static WBUploadImgManager *_manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        /*
         $id= 'LTAIdixMano9JUrT';
         $key= '1aJDsJjYXB0gfbkOCgXFSYJ4mNn9jT';
         $host = 'http://heima750.oss-cn-beijing.aliyuncs.com';
         */
        NSString *AccessKey = @"LTAIdixMano9JUrT";
        NSString *SecretKey = @"1aJDsJjYXB0gfbkOCgXFSYJ4mNn9jT";
        NSString *endPoint = @"http://oss-cn-beijing.aliyuncs.com";
        
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey secretKey:SecretKey];

//        NSDictionary *dict = [[WBRequestManager shareManager]synchronizationRequstWithMethod:@"GET" Parameter:nil urlString:@"http://service.heima750.cn/getalisign.php"];
//        WBLog(@"%@",dict);
//        //http://service.heima750.cn/getalisign.php
//        id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
//            NSString *string = [NSString stringWithFormat:@"OSS %@:%@", dict[@"accessid"], dict[@"signature"]];
//            WBLog(@"%@",string);
//            return string;
//        }];
        
        _manager = [[WBUploadImgManager alloc] initWithEndpoint:endPoint credentialProvider:credential];
    });
    return _manager;
}
#pragma mark - 原画 上传
- (void)uploadOriginalImage:(UIImage *)image objectKey:(NSString *)objKey withReceiveBlock:(uploadImgReceiveBlock)block
{
    //kSHOW_LOADING;
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"heima750";
    put.objectKey = objKey;
    put.uploadingData = data;
    
//    [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://tva4.sinaimg.cn/crop.0.0.512.512.1024/913c1e23jw8ewulfhap5cj20e80e80t3.jpg"]];
//    put.uploadingFileURL = [NSURL URLWithString:@"http://tva4.sinaimg.cn/crop.0.0.512.512.1024/913c1e23jw8ewulfhap5cj20e80e80t3.jpg"];
//    put.contentType = @"image/jpeg";
    
    //进度
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        WBLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask *putTask = [self putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        //kHIDDEN_LOADING;
        if (!task.error) {
            WBLog(@"upload object success!");
        } else {
            WBLog(@"upload object failed, error: %@" , task.error);
        }
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(!task.error);
            });
        }
        return nil;
    }];
}

@end

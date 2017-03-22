//
//  WBUploadImgManager.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/20.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>

typedef void(^uploadImgReceiveBlock)(BOOL yesOrNo);
@interface WBUploadImgManager : OSSClient

/**类方法 单例*/
+ (WBUploadImgManager *)shareClient;

/**原尺寸 上传图片*/
- (void)uploadOriginalImage:(UIImage *)image objectKey:(NSString *)objKey withReceiveBlock:(uploadImgReceiveBlock)block;

@end

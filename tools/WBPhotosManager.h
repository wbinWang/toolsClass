//
//  WBPhotosManager.h
//  happyBear
//
//  Created by wenbin on 2017/2/4.
//  Copyright © 2017年 嗨皮熊. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^saveCompleteBlock)(BOOL saveSeccess);

@interface WBPhotosManager : NSObject

+ (WBPhotosManager *)shareManager;

/**
 *  保存视频到本地
 */
- (void)saveVideoWithFileURLPath:(NSString *)filePath withSaveComplete:(saveCompleteBlock)block;
/**
 *  保存图片到本地 1
 */
- (void)saveImageWithImage:(UIImage *)img withCompleteBlock:(saveCompleteBlock)block;

@end

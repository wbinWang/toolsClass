//
//  WBFileCachesManager.h
//  happyBear
//
//  Created by wenbin on 2017/2/13.
//  Copyright © 2017年 嗨皮熊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  清除文件缓存的类
 */
@interface WBFileCachesManager : NSObject

+ (WBFileCachesManager *)defaultManager;

/**
 *  计算缓存大小
 */
- (NSString *)caculateCachesSize;

/**
 *  清除
 */
- (void)clearCaches;

/**
 *  删除某路径文件
 */
- (void)clearOneFile:(NSString *)oneFilePath;

@end

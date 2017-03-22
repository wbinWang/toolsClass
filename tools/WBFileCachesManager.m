//
//  WBFileCachesManager.m
//  happyBear
//
//  Created by wenbin on 2017/2/13.
//  Copyright © 2017年 嗨皮熊. All rights reserved.
//

#import "WBFileCachesManager.h"
@interface WBFileCachesManager()
{
    
}

@property (nonatomic , strong)NSArray *clearFilePaths;

@end

@implementation WBFileCachesManager

- (instancetype)init
{
    if (self = [super init]) {
        //图片缓存
        self.clearFilePaths = @[kCachesSDImagePath];
    }
    return self;
}

+ (WBFileCachesManager *)defaultManager
{
    static WBFileCachesManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[WBFileCachesManager alloc] init];
    });
    return manager;
}

#pragma mark - 计算大小
- (NSString *)caculateCachesSize
{
    NSInteger total = 0;
    for (NSString *path in self.clearFilePaths) {
        WBLog(@"清除缓存 路径 %@",path);
        total += [self fileDataSizeWith:path alsoRemove:NO];
    }
    return [self convertIntSize2String:total];
}
//计算单个文件夹大小
- (NSInteger)fileDataSizeWith:(NSString *)filePath alsoRemove:(BOOL)remove
{
    NSFileManager *fileMag = [NSFileManager defaultManager];
    
    //用于累计缓存图片总大小
    NSInteger totalSize = 0;
    
    if ([fileMag fileExistsAtPath:filePath]) {
        
        NSArray *subFilesArray = [fileMag contentsOfDirectoryAtPath:filePath error:nil];
        
        for(NSString *fileName in subFilesArray) {
            
            NSString *fullPath = [filePath stringByAppendingPathComponent:fileName];
            
            BOOL isDir = NO;
            if([fileMag fileExistsAtPath:fullPath isDirectory:&isDir]) {
                
                if (isDir) {
                    //文件夹
                    totalSize += [self fileDataSizeWith:fullPath alsoRemove:remove];
                    
                }else {
                    if (remove) {
                        //删除
                        [fileMag removeItemAtPath:filePath error:nil];
                    }else {
                        //计算大小
                        NSDictionary *attributesDict = [fileMag attributesOfItemAtPath:fullPath error:nil];
                        //byte为单位
                        NSString *fileSize = [attributesDict objectForKey:NSFileSize];
//                        WBLog(@"fileSize %@ %@",fileName , fileSize);
                        totalSize += fileSize.integerValue;
                    }
                }
            }
        }
    }
    return totalSize;
}
//计算缓存的占用存储大小
- (NSString *)convertIntSize2String:(NSInteger)cacheSize
{
    if (cacheSize < 1024)
        return [NSString stringWithFormat:@"%ld B",(long)cacheSize];
    else if(cacheSize > 1024 && cacheSize < 1024*1024)
        return [NSString stringWithFormat:@"%.2f K",(float)cacheSize/1024];
    else if(cacheSize > 1024*1024 && cacheSize < 1024*1024*1024)
        return [NSString stringWithFormat:@"%.2f M",(float)cacheSize/(1024*1024)];
    else
        return [NSString stringWithFormat:@"%.2f G",(float)cacheSize/(1024*1024*1024)];
}

#pragma mark - 清除
- (void)clearCaches
{
    NSFileManager *fileMag = [NSFileManager defaultManager];
    for (NSString *path in self.clearFilePaths) {
        [fileMag removeItemAtPath:path error:nil];
    }
}
- (void)clearOneFile:(NSString *)oneFilePath
{
    NSFileManager *fileMag = [NSFileManager defaultManager];
    [fileMag removeItemAtPath:oneFilePath error:nil];
}
@end

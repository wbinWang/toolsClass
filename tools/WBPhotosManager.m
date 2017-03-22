//
//  WBPhotosManager.m
//  happyBear
//
//  Created by wenbin on 2017/2/4.
//  Copyright © 2017年 嗨皮熊. All rights reserved.
//

#import "WBPhotosManager.h"
#import <Photos/Photos.h>
@interface WBPhotosManager()
{
    NSString *_folderName;
    BOOL _isExistFolder;
}
@property (nonatomic , copy)saveCompleteBlock completeBlock;

/**
 *  图片的文件地址
 */
//@property (nonatomic , copy)NSString *imageFilePath;
/**
 *  图片
 */
@property (nonatomic , weak)UIImage *needSaveImg;
/**
 *  视频的文件地址
 */
@property (nonatomic , copy)NSString *videoFilePath;

@end
@implementation WBPhotosManager

#pragma mark - 初始化
+ (WBPhotosManager *)shareManager
{
    static WBPhotosManager *manager;
    if (!manager) {
        manager = [[WBPhotosManager alloc]init];
    }
    return manager;
}
- (instancetype)init
{
    if (self = [super init]) {
        _folderName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
//        _folderName = @"酷熊星球";
        if (![self isExistSelfFolder]) {
            [self createSelfFolder];
        }
    }
    return self;
}
//判断是否存在该文件夹
- (BOOL)isExistSelfFolder
{
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    __block BOOL isExisted = NO;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:_folderName])  {
            isExisted = YES;
        }
    }];
    _isExistFolder = isExisted;
    return isExisted;
}
//创建相册文件夹
- (void)createSelfFolder
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //添加文件夹
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:_folderName];
            
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            WBLog(@"创建相册文件夹成功!");
            _isExistFolder = YES;
            
            //再次保存~
            if (self.videoFilePath) {
                [self saveVideoWithFileURLPath:self.videoFilePath withSaveComplete:self.completeBlock];
            }else if (self.needSaveImg) {
                [self saveImageWithImage:self.needSaveImg withCompleteBlock:self.completeBlock];
            }
            
        } else {
            WBLog(@"创建相册文件夹失败:%@", error);
        }
    }];
}
#pragma mark - 保存
/**
 *  保存视频到本地
 */
- (void)saveVideoWithFileURLPath:(NSString *)filePath withSaveComplete:(saveCompleteBlock)block
{
    self.videoFilePath = filePath;
    self.completeBlock = block;
    
    if (!_isExistFolder) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    //标识保存到系统相册中的标识
    __block NSString *localIdentifier;
    
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        
        //folderName是我们写入照片的相册
        WBLog(@"相册文件夹名字%@",assetCollection.localizedTitle);
        if ([assetCollection.localizedTitle isEqualToString:_folderName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                
                //相册中添加视频
                [collectonRequest addAssets:@[placeHolder]];
                
                localIdentifier = placeHolder.localIdentifier;
                
            } completionHandler:^(BOOL success, NSError *error) {
                
                if (self.completeBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.completeBlock(success);
                    });
                }
                if (success) {
                    
                    WBLog(@"保存视频成功!");
                    self.videoFilePath = nil;
                    
                } else {
                    WBLog(@"保存视频失败:%@", error);
                    //转存到系统相册
                }
                self.completeBlock = nil;
            }];
        }
    }];
}
/**
 *  保存图片到本地 1
 */
- (void)saveImageWithImage:(UIImage *)img withCompleteBlock:(saveCompleteBlock)block
{
    self.needSaveImg = img;
    self.completeBlock = block;
    
    if (!_isExistFolder) {
        return;
    }

    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //Camera Roll是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:_folderName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:img];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加照片
                [collectonRequest addAssets:@[placeHolder]];
                
            } completionHandler:^(BOOL success, NSError *error) {
                
                if (self.completeBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.completeBlock(success);
                    });
                }
                if (success) {
                    WBLog(@"保存图片成功!");
                } else {
                    WBLog(@"保存图片失败:%@", error);
                }
                self.needSaveImg = nil;
                self.completeBlock = nil;
            }];
        }
    }];
}
/**
 *  保存视频到本地 2
 */
//- (void)saveImageWithFileURLPath:(NSString *)filePath withCompleteBlock:(saveCompleteBlock)block
//{
//    self.imageFilePath = filePath;
//    self.completeBlock = block;
//    
//    if (!_isExistFolder) {
//        return;
//    }
//    
//    NSURL *url = [NSURL fileURLWithPath:filePath];
//    
//    //标识保存到系统相册中的标识
//    __block NSString *localIdentifier;
//    
//    //首先获取相册的集合
//    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
//    //对获取到集合进行遍历
//    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        PHAssetCollection *assetCollection = obj;
//        //Camera Roll是我们写入照片的相册
//        if ([assetCollection.localizedTitle isEqualToString:_folderName])  {
//            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                //请求创建一个Asset
//                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:url];
//                //请求编辑相册
//                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//                //为Asset创建一个占位符，放到相册编辑请求中
//                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
//                //相册中添加照片
//                [collectonRequest addAssets:@[placeHolder]];
//                
//                localIdentifier = placeHolder.localIdentifier;
//            } completionHandler:^(BOOL success, NSError *error) {
//                
//                if (success) {
//                    WBLog(@"保存图片成功!");
//                } else {
//                    WBLog(@"保存图片失败:%@", error);
//                }
//            }];
//        }
//    }];
//}
@end

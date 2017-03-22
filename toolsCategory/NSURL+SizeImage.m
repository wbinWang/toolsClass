//
//  NSURL+SizeImage.m
//  ComradeUncle
//
//  Created by wenbin on 16/6/25.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "NSURL+SizeImage.h"

@implementation NSURL (SizeImage)

+ (NSURL *)URLWithString:(NSString *)string accordingToWidth:(NSInteger)width
{
    if ([string hasPrefix:@"http://wx.qlogo.cn"]) {
        //来自微信
        return [self URLWithString:string];
    }else if ([string containsString:@"sinaimg"]) {
        //来自微博
        //http://tva4.sinaimg.cn/crop.0.0.512.512.1024/913c1e23jw8ewulfhap5cj20e80e80t3.jpg
        return [self URLWithString:string];
    }else if ([string hasPrefix:@"http://video.kuxiongzhibo.com"]) {
        //视频截帧
        return [self URLWithString:string];
    }
    if (kIS_IPHONE_6P) {
        width = width * 3;
    }else {
        width = width * 2;
    }
    //旧版本
//    NSString *newStr = [string stringByAppendingFormat:@"@%ldw.png",width];
    //新版本
    //http://cdn.kuxiongzhibo.com/30956c857fc1728b9812139ae0f789ab.png
    //?x-oss-process=image/resize,h_100/circle,r_50/format,png
    
    NSString *newStr = [string stringByAppendingFormat:@"?x-oss-process=image/resize,h_%ld/format,png",width];
    return [self URLWithString:newStr];
}
+ (NSURL *)URLWithString:(NSString *)string accordingToWidth:(NSInteger)width circleRadius:(NSInteger)radius
{
    if ([string hasPrefix:@"http://wx.qlogo.cn"]) {
        //来自微信
        return [self URLWithString:string];
    }else if ([string containsString:@"sinaimg"]) {
        //来自微博
        //http://tva4.sinaimg.cn/crop.0.0.512.512.1024/913c1e23jw8ewulfhap5cj20e80e80t3.jpg
        return [self URLWithString:string];
    }
    if (kIS_IPHONE_6P) {
        width = width * 3;
        radius = radius * 3;
    }else {
        width = width * 2;
        radius = radius * 2;
    }
    //?x-oss-process=image/resize,h_100/circle,r_50/format,png
    
    NSString *newStr = [string stringByAppendingFormat:@"?x-oss-process=image/resize,h_%ld/circle,r_%ld/format,png",width,radius];
    return [self URLWithString:newStr];
}
@end

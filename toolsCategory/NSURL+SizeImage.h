//
//  NSURL+SizeImage.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/25.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SizeImage)

/**按宽度 取图片 方形 width:物理尺寸*/
+ (NSURL *)URLWithString:(NSString *)string accordingToWidth:(NSInteger)width;

/**按宽度 取图片 圆角图 width:物理尺寸 radius:圆角尺寸*/
+ (NSURL *)URLWithString:(NSString *)string accordingToWidth:(NSInteger)width circleRadius:(NSInteger)radius;

@end

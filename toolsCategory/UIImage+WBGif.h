//
//  UIImage+WBGif.h
//  ComradeUncle
//
//  Created by wenbin on 16/7/27.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WBGif)

@property (nonatomic , weak)void(^gifFinishBlock)(NSTimeInterval);

//+ (UIImage *)wb_animatedGIFNamed:(NSString *)name;

+ (UIImage *)wb_animatedGIFWithData:(NSData *)data withGifAniFinishBlock:(void(^)(NSTimeInterval))block;

- (UIImage *)wb_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end

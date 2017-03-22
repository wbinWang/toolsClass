//
//  UIImageView+DrawCircleImage.m
//  happyBear
//
//  Created by wenbin on 2016/11/16.
//  Copyright © 2016年 嗨皮熊. All rights reserved.
//

#import "UIImageView+DrawCircleImage.h"

@implementation UIImageView (DrawCircleImage)

/**
 * 重新绘制图片，从方形，变为圆形
 */
- (void)drawCircleImageSourceImg:(UIImage *)sourceImg cornerRadius:(CGFloat)radius
{
    self.image = sourceImg;
    
    CGSize size = self.bounds.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 4 * size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    //圆角曲线
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(context, bezier.CGPath);
    CGContextClip(context);
    
    CGContextDrawImage(context, rect, sourceImg.CGImage);
//    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    self.image = [UIImage imageWithCGImage:imgRef];
    
    UIGraphicsEndImageContext();

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imgRef);
}


@end

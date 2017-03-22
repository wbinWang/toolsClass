//
//  UIColor+expand.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/17.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Expand)


//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
/**从十六进制字符串获取颜色*/
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**从十六进制字符串获取颜色 alpha为1*/
+ (UIColor *)colorWithHexString:(NSString *)color;

@end

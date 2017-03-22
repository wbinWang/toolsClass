//
//  UILabel+Attributed.h
//  DarkHorse750
//
//  Created by wenbin on 2017/3/1.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  添加attribute string
 */
@interface UILabel (Attributed)

/**
 *  行间距
 */
- (void)attributedWithText:(NSString *)text paragraphHight:(CGFloat)hight;

/**
 *  默认灰色文字阴影
 */
- (void)attributedWithTextDefaultGrayShadow:(NSString *)text;
@end

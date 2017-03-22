//
//  UIView+Extra.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/21.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extra)

/**为View添加点击事件*/
- (void)addTarget:(nullable id)target action:(SEL _Nonnull)action;

/**
 *  添加渐变layer
 */
- (void)addGradientLayerWithStarColor:(nullable UIColor *)sColor
                             endColor:(nullable UIColor *)eColor
                            starPoint:(CGPoint)sP
                             endPoint:(CGPoint)eP;
@end

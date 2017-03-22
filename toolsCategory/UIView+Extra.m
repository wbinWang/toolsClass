//
//  UIView+Extra.m
//  ComradeUncle
//
//  Created by wenbin on 16/6/21.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

#pragma mark - 添加事件
- (void)addTarget:(nullable id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    if (![[self.subviews lastObject] isKindOfClass:[UIControl class]]) {
        UIControl *cont = [[UIControl alloc]initWithFrame:self.bounds];
        [cont addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cont];
    }
}

#pragma mark - 添加渐变layer
- (void)addGradientLayerWithStarColor:(UIColor *)sColor endColor:(UIColor *)eColor starPoint:(CGPoint)sP endPoint:(CGPoint)eP
{
    //layer
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.startPoint = sP;
    gradient.endPoint = eP;
    
    gradient.colors = @[(id)sColor.CGColor , (id)eColor.CGColor];
    gradient.locations = @[@(0) , @(1)];
    gradient.frame = self.bounds;
    
    [self.layer insertSublayer:gradient atIndex:0];
}

@end

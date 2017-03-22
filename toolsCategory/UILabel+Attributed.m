//
//  UILabel+Attributed.m
//  DarkHorse750
//
//  Created by wenbin on 2017/3/1.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

#import "UILabel+Attributed.h"

@implementation UILabel (Attributed)

- (void)attributedWithText:(NSString *)text paragraphHight:(CGFloat)hight
{
    if (![text isKindOfClass:[NSString class]]) {
        return;
    }
    NSMutableParagraphStyle *paragarph = [[NSMutableParagraphStyle alloc]init];

    paragarph.minimumLineHeight = hight;
    paragarph.maximumLineHeight = hight;
    paragarph.alignment = NSTextAlignmentLeft;
    paragarph.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSDictionary * dict = @{NSParagraphStyleAttributeName:paragarph};
    
    NSAttributedString *att = [[NSAttributedString alloc]initWithString:text attributes:dict];
    
    self.attributedText = att;
}

- (void)attributedWithTextDefaultGrayShadow:(NSString *)text
{
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeMake(0, 0.5);
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:text
                                                                   attributes:@{NSShadowAttributeName:shadow}];
    
    self.attributedText = attribute;
}

@end

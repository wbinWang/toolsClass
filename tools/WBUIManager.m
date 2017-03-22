//
//  WBUIManager.m
//  happyBear
//
//  Created by wenbin on 2017/2/15.
//  Copyright © 2017年 嗨皮熊. All rights reserved.
//

#import "WBUIManager.h"

@implementation WBUIManager

+ (WBUIManager *)defaultManager
{
    static WBUIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WBUIManager alloc]init];
    });
    return manager;
}

#pragma mark - label
- (UILabel *)labelBaseInitWithFrame:(CGRect)frame Text:(NSString *)text Font:(UIFont *)font Color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = color;
    return label;
}
- (UILabel *)labelInitWithFrame:(CGRect)frame Text:(NSString *)text FontRegularSize:(CGFloat)fontS ColorHexStr:(NSString *)colorS
{
    return [self labelBaseInitWithFrame:frame Text:text Font:[toolsClass FontNameRegularWithSize:fontS] Color:[toolsClass colorWithHexString:colorS]];
}

#pragma mark - image view
- (UIImageView *)imgViewBaseInitWithFrame:(CGRect)frame localImgName:(NSString *)name
{
    UIImageView *img = [[UIImageView alloc]initWithFrame:frame];
    img.image = [UIImage imageNamed:name];
    img.contentMode = UIViewContentModeScaleAspectFit;
    return img;
}
- (UIImageView *)imgViewInitWithFrame:(CGRect)frame ImgUrl:(NSString *)imgUrl PlaceImg:(NSString *)localName
{
    UIImageView *iv = [self imgViewBaseInitWithFrame:frame localImgName:localName];
    [iv sd_setImageWithURL:[NSURL URLWithString:imgUrl accordingToWidth:kLittleAvatarW] placeholderImage:[UIImage imageNamed:localName]];
    return iv;
}

#pragma mark - button
- (UIButton *)buttonBaceInitWithFrame:(CGRect)frame Image:(NSString *)imgName Text:(NSString *)text Target:(nullable id)target Action:(nullable SEL)action
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    btn.backgroundColor = [UIColor clearColor];
    
    if (imgName) {
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
    }
    if (text) {
        [btn setTitle:text forState:UIControlStateNormal];
    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return btn;
}
- (UIButton *)btnTextInitWithFrame:(CGRect)frame Text:(NSString *)text Font:(UIFont *)font NormalTextColor:(NSString *)nColor SelTextColor:(NSString *)sColor Target:(nullable id)target Action:(nullable SEL)action
{
    UIButton *btn = [self buttonBaceInitWithFrame:frame Image:nil Text:text Target:target Action:action];
    [btn setTitleColor:[UIColor colorWithHexString:nColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:sColor] forState:UIControlStateSelected];
    [btn.titleLabel setFont:font];
    
    return btn;
}
//- (UIButton *)btnImageInitWithFrame:(CGRect)frame normalImg:(NSString *)nImg selectImg:(NSString *)sImg Target:(nullable id)target Action:(nullable SEL)action
//{
//    UIButton *btn = [self buttonBaceInitWithFrame:frame Image:nil Text:@"" Target:target Action:action];
//    [btn setImage:[UIImage imageNamed:sImg] forState:UIControlStateSelected];
//    
//}
@end

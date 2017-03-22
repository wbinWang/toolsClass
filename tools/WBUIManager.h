//
//  WBUIManager.h
//  happyBear
//
//  Created by wenbin on 2017/2/15.
//  Copyright © 2017年 嗨皮熊. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  UI 初始化类
 */
@interface WBUIManager : NSObject

+ (WBUIManager *)defaultManager;

/**
 *  UILabel base初始化
 */
- (UILabel *)labelBaseInitWithFrame:(CGRect)frame Text:(NSString *)text Font:(UIFont *)font Color:(UIColor *)color;
/**
 *  UILabel 初始化
 */
- (UILabel *)labelInitWithFrame:(CGRect)frame Text:(NSString *)text FontRegularSize:(CGFloat)fontS ColorHexStr:(NSString *)colorS;


/**
 *  UIImageView base初始化
 */
- (UIImageView *)imgViewBaseInitWithFrame:(CGRect)frame localImgName:(NSString *)name;
/**
 *  UIImageView base初始化
 */
- (UIImageView *)imgViewInitWithFrame:(CGRect)frame ImgUrl:(NSString *)imgUrl PlaceImg:(NSString *)localName;


/**
 *  UIButton base初始化
 */
- (UIButton *)buttonBaceInitWithFrame:(CGRect)frame Image:(NSString *)imgName Text:(NSString *)text Target:(nullable id)target Action:(nullable SEL)action;

- (UIButton *)btnTextInitWithFrame:(CGRect)frame Text:(NSString *)text Font:(UIFont *)font NormalTextColor:(NSString *)nColor SelTextColor:(NSString *)sColor Target:(nullable id)target Action:(nullable SEL)action;

//- (UIButton *)btnImageInitWithFrame:(CGRect)frame normalImg:(NSString *)nImg selectImg:(NSString *)sImg Target:(nullable id)target Action:(nullable SEL)action;

@end

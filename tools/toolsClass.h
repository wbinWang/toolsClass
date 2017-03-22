//
//  toolsClass.h
//  yeeda1.1
//
//  Created by yeeda on 15/6/13.
//  Copyright (c) 2015年 iyeeda. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface toolsClass : NSObject

/**
 *  同意访问相机
 */
@property (nonatomic , assign)BOOL canVisitCamera;
/**
 *  同意访问麦克风
 */
@property (nonatomic , assign)BOOL canVisitMicro;

+ (toolsClass *)defaultTools;

/**文字所占大小*/
+(CGSize)calculateTextSize:(NSString *)text withFont:(UIFont *)font limitSize:(CGSize)size;
/**带行间距的大小*/
+(CGSize)calculateTextSize:(NSString *)text withFontFloat:(CGFloat)fontSize lineHeightFloat:(CGFloat)lineSpacing limitSize:(CGSize)size;

/**带行高 字体 UILabel*/
+(CGSize)calculateLableTextSize:(NSString *)text withFont:(UIFont *)font lineHeightFloat:(CGFloat)lineSpacing limitSize:(CGSize)size;
/**带行高 + 首航缩进 + 字体 UILabel*/
+(CGSize) calculateLableTextSize:(NSString *)text withFont:(UIFont *)font lineHeightFloat:(CGFloat)lineSpacing limitSize:(CGSize)size withFirstLineHeadIndent:(CGFloat)indent;
/**attributeString 的 size*/
+(CGSize)attributeStringBounce:(NSAttributedString *)attStr withMaxSize:(CGSize)size;
/**
 *  按尺寸 绘制图片
 *
 *  @param img  <#img description#>
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
/**
 *  重新绘制为正方形 切割 图片
 *
 *  @param oldImg <#oldImg description#>
 *  @param size   <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)afreshDraw2SquareImg:(UIImage *)oldImg size:(CGSize)size;

/**短音频播放*/
+ (void)playShortSounds;

/**进制颜色 转为颜色*/
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**遍历字体*/
+ (void) enumerateFonts;

/**细 字体*/
+ (UIFont *)FontNameLightWithSize:(CGFloat)size;
/**正常字体*/
+ (UIFont *)FontNameRegularWithSize:(CGFloat)size;
/**中粗字体*/
+ (UIFont *)FontNameMediumWithSize:(CGFloat)size;
/**粗字体*/
+ (UIFont *)FontNameSemiboldWithSize:(CGFloat)size;

/**时间转换*/
+ (NSString *)dateTransform:(double)num;

/**检测emoji表情*/
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**检测私有参数 是否存在*/
+ (BOOL)detectionClass:(Class)className andValueStr:(NSString *)str;

/**获取手机所在地*/
+ (NSString *)localAreaCode;

/**view 转化为 image*/
+ (UIImage*)imageFromView:(UIView*)view;

/**
 *  当前版本是否通过审核
 *
 *  @param version 线上版本号
 *
 *  @return 1：表示为审核通过版本
 */
+ (BOOL)currentVersionIsPass:(NSNumber *)version;
/**
 *  当前版本是否低于线上版本
 *
 *  @param version 线上版本号
 *
 *  @return 1：表示为审核通过版本
 */
+ (BOOL)currentVerLessThanOnlineVer:(NSNumber *)version;
/**
 *  获取手机型号
 */
+ (NSString *)getCurrentDeviceModel;
/**
 *  判断手机型号是否小于5s
 */
+ (BOOL)is5s;
/**
 *  剔除掉搜狗输入法里面，不识别的字符‍。
 */
+ (NSString *)replaceTextUnusualString:(NSString *)oldString;

/**
 *  检测是否登录~
 */
+ (BOOL)judgeLogined;

/**
 *  两张图片合成一张~
 */
+ (UIImage *)composeImgBackImg:(UIImage *)backImg withBackFrame:(CGRect)bF withFrontImg:(UIImage *)frontImg withFrontFrame:(CGRect)fF;
@end

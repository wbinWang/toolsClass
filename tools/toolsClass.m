//
//  toolsClass.m
//  yeeda1.1
//
//  Created by yeeda on 15/6/13.
//  Copyright (c) 2015年 iyeeda. All rights reserved.
//

#import "toolsClass.h"
//短音频播放
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#include <sys/sysctl.h> //设备信息
#define ORIGINAL_MAX_WIDTH kWIDTH
@implementation toolsClass
+ (toolsClass *)defaultTools
{
    static toolsClass *_share;
    if (!_share) {
        _share = [[toolsClass alloc]init];
        [_share privacyVisitAudio];
        [_share privacyVisitVideo];
    }
    return _share;
}
#pragma mark - 访问权限
/**
 *  摄像头
 */
- (void)privacyVisitVideo {
    
    //同意访问
    void (^permissionGranted)(void) = ^{
        self.canVisitCamera = YES;
    };
    
    void (^noPermission)(void) = ^{
        WBLog(@"相机不同意访问");
        self.canVisitCamera = NO;
    };
    
    void (^requestPermission)(void) = ^{
        //请求访问相机
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                permissionGranted();
            } else {
                noPermission();
            }
        }];
    };
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            //同意访问相机
            permissionGranted();
            break;
        case AVAuthorizationStatusNotDetermined:
            //请求访问相机
            requestPermission();
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        default:
            //不同意访问相机
            noPermission();
            break;
    }
}
/**检测是否同意访问麦克风*/
- (void)privacyVisitAudio
{
    void (^permissionGranted)(void) = ^{
        self.canVisitMicro = YES;
    };
    void (^noPermission)(void) = ^{
        WBLog(@"麦克风不同意访问");
        self.canVisitMicro = NO;
    };
    
    void (^requestPermission)(void) = ^{
        //请求访问麦克风
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                permissionGranted();
            } else {
                noPermission();
            }
        }];
    };
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            //同意访问麦克风
            permissionGranted();
            break;
        case AVAuthorizationStatusNotDetermined:
            //请求访问麦克风
            requestPermission();
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        default:
            //不同意访麦克风
            noPermission();
            break;
    }
}

#pragma mark - tools
/**label*/
+(CGSize) calculateTextSize:(NSString *)text withFont:(UIFont *)font limitSize:(CGSize)size
{
    NSDictionary * dict = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
}
/**带每行 行高 textView*/
+(CGSize) calculateTextSize:(NSString *)text withFontFloat:(CGFloat)fontSize lineHeightFloat:(CGFloat)lineSpacing limitSize:(CGSize)size
{
    NSMutableParagraphStyle *paragarph = [[NSMutableParagraphStyle alloc]init];
    //paragarph.lineHeightMultiple = lineSpacing;
    paragarph.minimumLineHeight = lineSpacing;
    paragarph.maximumLineHeight = lineSpacing;
    paragarph.lineBreakMode = NSLineBreakByCharWrapping;
    paragarph.alignment = NSTextAlignmentJustified;
    
    NSDictionary * dict = @{
                            NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                            NSParagraphStyleAttributeName:paragarph
                            };
    size = CGSizeMake(size.width - 16, size.height);
    
    CGSize returnSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    return CGSizeMake(returnSize.width, returnSize.height + 16);
}
/**带行高 字体 uilabel*/
+(CGSize) calculateLableTextSize:(NSString *)text withFont:(UIFont *)font lineHeightFloat:(CGFloat)lineSpacing limitSize:(CGSize)size
{
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle *paragarph = [[NSMutableParagraphStyle alloc]init];
    //paragarph.lineHeightMultiple = lineSpacing;
    paragarph.minimumLineHeight = lineSpacing;
    paragarph.maximumLineHeight = lineSpacing;
    paragarph.alignment = NSTextAlignmentJustified;
    paragarph.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary * dict = @{
                            NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragarph
                            };
    size = CGSizeMake(size.width, size.height);
    
    CGSize returnSize = [text boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:dict
                                           context:nil].size;
    return CGSizeMake(returnSize.width, returnSize.height);
}
/**带行高 + 首航缩进 + 字体 UILabel*/
+(CGSize) calculateLableTextSize:(NSString *)text withFont:(UIFont *)font lineHeightFloat:(CGFloat)lineSpacing limitSize:(CGSize)size withFirstLineHeadIndent:(CGFloat)indent
{
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle *paragarph = [[NSMutableParagraphStyle alloc]init];
    //paragarph.lineHeightMultiple = lineSpacing;
    paragarph.minimumLineHeight = lineSpacing;
    paragarph.maximumLineHeight = lineSpacing;
    paragarph.alignment = NSTextAlignmentJustified;
    paragarph.lineBreakMode = NSLineBreakByCharWrapping;
    paragarph.firstLineHeadIndent = indent;
    
    NSDictionary * dict = @{
                            NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragarph
                            };
    size = CGSizeMake(size.width, size.height);
    
    CGSize returnSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    return CGSizeMake(returnSize.width, returnSize.height);
}
/**attributeString 的 size*/
+(CGSize) attributeStringBounce:(NSAttributedString *)attStr withMaxSize:(CGSize)size
{
    if (!attStr || ![attStr isKindOfClass:[NSAttributedString class]]) {
        return CGSizeZero;
    }
    CGSize returnSize = [attStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return CGSizeMake(returnSize.width, returnSize.height);
}
#pragma mark - 图片压缩
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
+ (UIImage *)afreshDraw2SquareImg:(UIImage *)oldImg size:(CGSize)size
{
    //原图片宽高比
    CGFloat xx = oldImg.size.height / oldImg.size.width;
    //转化为位图
    CGImageRef temImg = oldImg.CGImage;
    //绘制范围
    CGRect drawFrame;
    if (xx > 1) {
        //高图片
        drawFrame = CGRectMake(0,(oldImg.size.height - oldImg.size.width) / 2.0, oldImg.size.width, oldImg.size.width);
    }else if (xx < 1) {
        //宽图片
        drawFrame = CGRectMake((oldImg.size.width - oldImg.size.height) / 2.0 , 0 , oldImg.size.height, oldImg.size.height);
    }else {
        drawFrame = CGRectMake( 0 , 0 , oldImg.size.width, oldImg.size.height);
    }
    
    //根据范围截图
    temImg = CGImageCreateWithImageInRect(temImg, drawFrame);
    //得到新的图片
    UIImage *new = [UIImage imageWithCGImage:temImg];
    //释放位图对象
    CGImageRelease(temImg);
    
    return [toolsClass scaleToSize:new size:size];
}
//复制代码
//压缩成指定大小代码
//
//
//
//
//
//
//
//等比压缩
//
//复制代码
//等比例压缩
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - 短音效
/**短音频播放*/
+ (void)playShortSounds
{
    /*
     UInt32 category = kAudioSessionCategory_PlayAndRecord;
     AudioSessionSetProperty(
     kAudioSessionCategory_PlayAndRecord,
     sizeof(category),
     &category);
     
     UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
     AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers,
     sizeof (audioRouteOverride),
     &audioRouteOverride);

     */
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:nil];
    
    NSURL *biteUrl = [[NSBundle mainBundle]URLForResource:@"boob.wav" withExtension:nil];
    //[[NSBundle mainBundle]URLForResource:@"kacha.mp3" withExtension:nil];
    if (biteUrl) {
        //声明一个音频的ID
        SystemSoundID soundID;
        //将ID和一个音频文件绑定到一起
        //通过名字和类型，找到包中的文件URL
        //第一个参数要把音频URL强转成这个类型CFURLRef
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)biteUrl, &soundID);
        
        //通过SoundID将音频托管给系统
        AudioServicesPlaySystemSound(soundID);
        AudioServicesPropertyID flag = 0;
        
        AudioServicesSetProperty(kAudioServicesPropertyIsUISound,
                                 sizeof(SystemSoundID),
                                 &soundID,
                                 sizeof(AudioServicesPropertyID) ,
                                 &flag);
    }
}

#pragma mark - 颜色转换
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


#pragma mark image scale utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [toolsClass imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
//- (float) heightForString:(NSString *)value fontSize:(float)fontSize andDrawingSize:(CGSize)size
//{
//////    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
////    NSDictionary *att = @{@"NSFontAttributeName":@"",
////                          @"":@""};
////    CGSize sizeTofit_8 = [value boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>]
////    return sizeToFit.height;
//}

#pragma mark - 遍历系统字体
+ (void) enumerateFonts{
    
    for(NSString *familyName in [UIFont familyNames]){
        
        WBLog(@"Font FamilyName = %@",familyName); //*输出字体族科名字
        
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]){
            
            WBLog(@"\t%@",fontName);         //*输出字体族科下字样名字
        }
    }
}
#pragma mark - 字体
/**细 字体*/
+ (UIFont *)FontNameLightWithSize:(CGFloat)size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }else
        return [UIFont systemFontOfSize:size];
}
/**正常字体*/
+ (UIFont *)FontNameRegularWithSize:(CGFloat)size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }else
        return [UIFont systemFontOfSize:size];
}
/**中粗字体*/
+ (UIFont *)FontNameMediumWithSize:(CGFloat)size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }else
        return [UIFont fontWithName:@"STHeitiSC-Medium" size:size];
}
/**粗字体*/
+ (UIFont *)FontNameSemiboldWithSize:(CGFloat)size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }else
        return [UIFont fontWithName:@"STHeitiSC-Medium" size:size];
}
//#define iOS9 SYSTEM_FLOAT_VER >= 9.0
//#if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0) ? 1 : 0
////正常
//#define FontNameRegular @"PingFangSC-Regular"
////中粗
//#define FontNameMedium @"PingFangSC-Medium"
////粗
//#define FontNameSemibold @"PingFangSC-Semibold"
//#else
///*
// STHeitiSC-Medium
// STHeitiSC-Light
// */
////正常
//#define FontNameRegular @"Heiti"
////中粗
//#define FontNameMedium @"STHeitiSC-Medium"
////粗
//#define FontNameSemibold @"STHeitiSC-Medium"
//#endif

#pragma mark - 时间转换
+ (NSString *)dateTransform:(double)num
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //后设置会顶替原设置
    formatter.dateFormat = @"yyyy年MM月dd日";
    
    //    return [formatter stringFromDate:date];
    NSTimeInterval gap = [[NSDate date]timeIntervalSinceDate:date];
    if (gap < 60) {
        //一分钟之内
        return [NSString stringWithFormat:@"%d秒前",(int)(gap)];
    }else if (gap < 60 * 60) {
        //一小时之内
        return [NSString stringWithFormat:@"%d分钟前",(int)(gap / 60.0)];
    }else if (gap < 60 * 60 * 24) {
        //一天之内
        return [NSString stringWithFormat:@"%d小时前",(int)(gap / 60.0 / 60.0)];
    }else if (gap < 60 * 60 * 24 * 3) {
        //三天之内
        return [NSString stringWithFormat:@"%d天前",(int)(gap / 60.0 / 60.0 / 24.0)];
    }else
        return [formatter stringFromDate:date];
}
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
/**检测私有参数 是否存在*/
+ (BOOL)detectionClass:(Class)className andValueStr:(NSString *)str
{
    uint count = 0;
    Ivar *subValues = class_copyIvarList(className, &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = subValues[i];
        
        const char *memberName = ivar_getName(var);
        const char *memberType = ivar_getTypeEncoding(var);
        WBLog(@"%s----%s", memberName, memberType);
        if ([[NSString stringWithFormat:@"%s",memberName] isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}
/**获取手机所在地*/
+ (NSString *)localAreaCode
{
    //区号对照表
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    //获取手机设置的位置
    NSLocale *locale = [NSLocale currentLocale];
    NSString *code = [locale objectForKey:NSLocaleCountryCode];
    NSString *defaultCode = [dictCodes objectForKey:code];
    
    NSString *countryCode =[NSString stringWithFormat:@"+%@",defaultCode];
    NSString *countryName = [locale displayNameForKey:NSLocaleCountryCode value:code];
    
//    _registerModel.countryCode = countryCode;
//    _registerModel.countryName = countryName;
    return [NSString stringWithFormat:@"%@ %@",countryCode , countryName];
}

#pragma mark - view转化为image
/**
 *  view转化为image
 *
 *  @param view <#view description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage*)imageFromView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

+ (BOOL)currentVersionIsPass:(NSNumber *)version
{
    return NO;
//    //判断版本是否展示提现
//    //已经上线版本号
//    NSString *versionStr = [NSString stringWithFormat:@"%@",version];
//    NSArray *subVersion = [versionStr componentsSeparatedByString:@"."];
//    
//    //当前版本号
//    NSString *currentStr = [NSString stringWithFormat:@"%.1f",currentAppVersion];
//    NSArray *currentSubVersion = [currentStr componentsSeparatedByString:@"."];
//    
//    //是否展示
//    BOOL show = NO;
//    if ([[subVersion firstObject] integerValue] > [[currentSubVersion firstObject] integerValue]) {
//        show = YES;
//    }else if ([[subVersion firstObject] integerValue] < [[currentSubVersion firstObject] integerValue]) {
//        show = NO;
//    }else {
//        if ([[subVersion lastObject] integerValue] >= [[currentSubVersion lastObject] integerValue]) {
//            show = YES;
//        }
//    }
//    return show;
}
+ (BOOL)currentVerLessThanOnlineVer:(NSNumber *)version
{
    return NO;
//    //判断版本是否展示提现0.9
//    //已经上线版本号
//    NSString *versionStr = [NSString stringWithFormat:@"%@",version];
//    NSArray *subVersion = [versionStr componentsSeparatedByString:@"."];
//    
//    //当前版本号
//    NSString *currentStr = [NSString stringWithFormat:@"%.1f",currentAppVersion];
//    NSArray *currentSubVersion = [currentStr componentsSeparatedByString:@"."];
//    
//    //是否展示
//    BOOL show = NO;
//    if ([[subVersion firstObject] integerValue] > [[currentSubVersion firstObject] integerValue]) {
//        show = YES;
//    }else if ([[subVersion firstObject] integerValue] < [[currentSubVersion firstObject] integerValue]) {
//        show = NO;
//    }else {
//        if ([[subVersion lastObject] integerValue] > [[currentSubVersion lastObject] integerValue]) {
//            show = YES;
//        }
//    }
//    return show;
}
+ (BOOL)is5s
{
    NSString *platform = [toolsClass getCurrentDeviceModel];
    NSArray *arr = [platform componentsSeparatedByString:@","];
    if ([[arr firstObject] hasPrefix:@"iPhone"]) {
        NSString *sub = [[arr firstObject] substringFromIndex:6];
        if ([sub integerValue] <= 6) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 获取手机型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    return platform;
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";//iPhone 4 (A1332)
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";//iPhone 4 (A1332)
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";//iPhone 4 (A1349)
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";//iPhone 4S (A1387/A1431)
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";//iPhone 5 (A1428)
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";//iPhone 5 (A1429/A1442)
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";//iPhone 5c (A1456/A1532)
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";//iPhone 5c (A1507/A1516/A1526/A1529)
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";//iPhone 5s (A1453/A1533)
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";//iPhone 5s (A1457/A1518/A1528/A1530)
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";//iPhone 6 Plus (A1522/A1524)
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 ";//iPhone 6 (A1549/A1586)
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
+ (NSString *)replaceTextUnusualString:(NSString *)oldString
{
    NSString *stringEncode = [oldString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    stringEncode = [stringEncode stringByReplacingOccurrencesOfString:@"%E2%80%8D" withString:@""];
    NSString *stringDecode = [stringEncode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WBLog(@"%@\n%@\n%@",oldString,stringEncode,stringDecode);
    
    return stringDecode;
}

#pragma mark - 是否登录
+ (BOOL)judgeLogined
{
    NSString *selfGuid = [kUserDefaults objectForKey:kSelfGuid];
    
    if (!selfGuid || !selfGuid.length) {
        [kNotiDefault postNotificationName:kUserNeedShowLogin object:nil];
        return NO;
    }else {
        return YES;
    }
}

#pragma mark - 两个图片合成一个
+ (UIImage *)composeImgBackImg:(UIImage *)backImg withBackFrame:(CGRect)bF withFrontImg:(UIImage *)frontImg withFrontFrame:(CGRect)fF
{
    CGSize backSize = backImg.size;
    CGSize frontSize = frontImg.size;
    WBLog(@"backSize=%@ frontSize=%@",NSStringFromCGSize(backSize),NSStringFromCGSize(frontSize));
    
    UIGraphicsBeginImageContextWithOptions(backSize, NO, [UIScreen mainScreen].scale);
    
    //背景画布
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contex, [UIColor whiteColor].CGColor);
    CGContextFillRect(contex, CGRectMake(0, 0, backSize.width, backSize.height));
    
    //背景图片图片
    [backImg drawInRect:bF];
    //前景图片
    [frontImg drawInRect:fF];
//    //背景图片图片
//    [backImg drawInRect:CGRectMake(0,
//                                   0,
//                                   backSize.width,
//                                   backSize.height)];
//    //前景图片
//    [frontImg drawInRect:CGRectMake((backSize.width - frontSize.width) / 2.0,
//                                   (backSize.height - frontSize.height) / 2.0,
//                                   frontSize.width,
//                                   frontSize.height)];
    
    UIImage *retureImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retureImg;
}

@end

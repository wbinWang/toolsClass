//
//  WBAlertBearDanceView.m
//  happyBear
//
//  Created by wenbin on 2016/11/4.
//  Copyright © 2016年 嗨皮熊. All rights reserved.
//
#import "WBAlertBearDanceView.h"
#import "UIImage+GIF.h"
@interface WBAlertBearDanceView ()
{
    
}

@property (nonatomic , weak)UIImageView *bearImgView;

@property (nonatomic , weak)UILabel *alertLabel;

@end
@implementation WBAlertBearDanceView
//小熊图片大小
static float bearImgSizeWidth = 100.0;
- (instancetype)init
{
    //@"主播上厕所啦…"@"主播被外星人抓走了…"
    if (self = [super initWithFrame:CGRectMake(0, 0, kWIDTH, bearImgSizeWidth + 20)]) {
        [self customUI];
    }
    return self;
}
- (void)customUI
{
    self.backgroundColor = [UIColor clearColor];
    
    //熊
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bearImgSizeWidth, bearImgSizeWidth)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.center = CGPointMake(self.center.x, self.center.y - 15);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xiongLoading" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    bgView.image = [UIImage sd_animatedGIFWithData:data];
    
    self.bearImgView = bgView;
    [self addSubview:bgView];
    
    //文字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + 2, kWIDTH, 17)];
    label.font = [toolsClass FontNameLightWithSize:16];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;

    self.alertLabel = label;
    [self addSubview:label];
}
- (void)settingLabelText:(NSString *)text
{
    //文字阴影
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeMake(0, 0.5);
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSShadowAttributeName:shadow}];
    
    self.alertLabel.attributedText = attribute;
}

@end

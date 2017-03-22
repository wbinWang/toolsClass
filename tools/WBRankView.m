//
//  WBRankView.m
//  ComradeUncle
//
//  Created by wenbin on 16/7/16.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "WBRankView.h"
@interface WBRankView()
{
    
}
/**
 *  正常等级label
 */
@property (nonatomic , weak)UILabel *randLabel;
/**
 *  小的 label
 */
@property (nonatomic , weak)UILabel *littleRandLabel;
@end
@implementation WBRankView

//- (instancetype)init
//{
//    if (self = [super init]) {
//        
//    }
//    return self;
//}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//    }
//    return self;
//}
//- (void)awakeFromNib
//{
//    
//}
- (UILabel *)randLabel
{
    if (!_randLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 2, 25, 11)];
        label.font = [toolsClass FontNameMediumWithSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        _randLabel = label;
    }
    return _randLabel;
}
- (void)setRank:(NSString *)rank
{
    if (!rank || !rank.length) {
        rank = @"1";
    }
    _rank = rank;
    self.randLabel.text = [NSString stringWithFormat:@"%@级",rank];
    
    NSInteger rankNum = [rank integerValue];
    NSString *imgStr;
    if (rankNum <= 10) {
        imgStr = @"yiji";
    }else if (10 < rankNum && rankNum <= 20) {
        imgStr = @"shiji";
    }else if (20 < rankNum && rankNum <= 30) {
        imgStr = @"ershiyiji";
    }else if (30 < rankNum && rankNum <= 40) {
        imgStr = @"sanshiyiji";
    }else if (40 < rankNum && rankNum <= 50) {
        imgStr = @"sishiyiji";
    }else if (50 < rankNum) {
        imgStr = @"wushiyiji";
    }
    self.image = [UIImage imageNamed:imgStr];
}
#pragma mark - 小的等级
- (UILabel *)littleRandLabel
{
    if (!_littleRandLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13, 2, 13, 11)];
        label.font = [toolsClass FontNameMediumWithSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        _littleRandLabel = label;
    }
    return _littleRandLabel;
}
- (void)setLittleRank:(NSString *)littleRank
{
    if (!littleRank || !littleRank.length) {
        littleRank = @"1";
    }
    _littleRank = littleRank;
    self.littleRandLabel.text = [NSString stringWithFormat:@"%@",littleRank];
    
    NSInteger rankNum = [littleRank integerValue];
    NSString *imgStr;
    if (rankNum <= 10) {
        imgStr = @"yiji_2";
    }else if (10 < rankNum && rankNum <= 20) {
        imgStr = @"shiyiji_2";
    }else if (20 < rankNum && rankNum <= 30) {
        imgStr = @"ershiyiji_2";
    }else if (30 < rankNum && rankNum <= 40) {
        imgStr = @"sanshiyiji_2";
    }else if (40 < rankNum && rankNum <= 50) {
        imgStr = @"sishiyiji_2";
    }else if (50 < rankNum) {
        imgStr = @"wushiyi_2";
    }
    self.image = [UIImage imageNamed:imgStr];
}
@end

//
//  WBHeaderGifRefresh.m
//  ComradeUncle
//
//  Created by wenbin on 16/7/30.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "WBHeaderGifRefresh.h"
@interface WBHeaderGifRefresh()
{
    
}
@property (nonatomic , weak)UIView *shadowView;
@end
@implementation WBHeaderGifRefresh
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        //内嵌阴影
//        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
//        view.layer.shadowOffset = CGSizeMake(0, -3);
//        view.layer.shadowColor = [UIColor colorWithHexString:@"666666" alpha:0.02].CGColor;
//        view.layer.shadowOpacity = 1;
//        view.layer.shadowRadius = 3.0;
//        self.shadowView = view;
//        [self addSubview:view];
        
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)prepare
{
    [super prepare];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=0; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"下拉加载_%ld", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=16; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"下拉加载_%ld", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.gifView.transform = CGAffineTransformMakeScale(0.5, 0.5);
}
#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (pullingPercent > 1) {
        return;
    }
    self.gifView.transform = CGAffineTransformMakeScale(0.5 + pullingPercent / 2.0, 0.5 + pullingPercent / 2.0);
}
- (void)placeSubviews
{
    [super placeSubviews];
    CGRect frame = self.gifView.frame ;
    frame.origin.y = 6;
    self.gifView.frame = frame;
    
    self.shadowView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1);
}
@end

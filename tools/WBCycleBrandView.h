//
//  WBShopTableHeaderView.h
//  yeeda0925
//
//  Created by wenbin on 16/3/3.
//  Copyright © 2016年 yeeda. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  tableview header 点击代理
 */
@protocol WBShopTableHeaderViewDelegate <NSObject>
/**
 *  header view 内部 collection 点击事件
 */
- (void)headViewClickWithIndex:(NSUInteger)index;

@end
@interface WBCycleBrandView : UIView
{
    
}
- (instancetype)initWithFrame:(CGRect)frame andBrands:(NSArray *)imgArr;

@property (weak, nonatomic)id <WBShopTableHeaderViewDelegate> delegate;

@property (nonatomic , strong)NSArray<NSString*>*titles;

@property (nonatomic , strong)NSArray *brandArray;

@property (nonatomic , assign)BOOL showPlayBtn;

@end

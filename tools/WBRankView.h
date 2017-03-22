//
//  WBRankView.h
//  ComradeUncle
//
//  Created by wenbin on 16/7/16.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBRankView : UIImageView


/**
 *  正常大小 等级 46 * 15
 */
@property (nonatomic , copy)NSString *rank;
/**
 *  评论cell 里面 小的 等级 27 * 15
 */
@property (nonatomic , copy)NSString *littleRank;

@end

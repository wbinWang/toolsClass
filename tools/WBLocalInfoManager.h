//
//  WBLocalInfoManager.h
//  DarkHorse750
//
//  Created by wenbin on 2017/3/3.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

#import <Foundation/Foundation.h>
//个人资料
#import "WBSelfInfoModel.h"
@interface WBLocalInfoManager : NSObject

/**
 *  读取个人资料
 */
+ (WBSelfInfoModel *)selfInfoModel;

/**
 *  保存个人资料
 */
+ (BOOL)saveUserInfo2LocalWithModel:(WBSelfInfoModel *)model;
+ (BOOL)saveUserInfo2Local:(NSDictionary *)infoDict;

/**
 *  移除个人资料
 */
+ (BOOL)removeUserInfoInLocal;
@end

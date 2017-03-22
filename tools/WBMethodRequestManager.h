//
//  WBMethodRequestManager.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/25.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "WBRequestManager.h"
//#import "WBSelfInfoModel.h"

//typedef void(^ReceiveMenberInfoBlock)(WBSelfInfoModel *model);

@interface WBMethodRequestManager : WBRequestManager

+ (WBMethodRequestManager *)shareManger;

#pragma mark - 订阅
/**订阅*/
- (void)attentionColumn:(NSNumber *)columnID completionBlock:(ReceiveBlock)block;
/**取消订阅*/
- (void)unAttentionColumn:(NSNumber *)columnID completionBlock:(ReceiveBlock)block;

#pragma mark - 喜欢收藏
/**
 *  喜欢
 */
- (void)likeWithId:(NSNumber *)oId withType:(WBMainModelType)type completionBlock:(ReceiveBlock)block;

//#pragma mark - 用户信息
///**
// *  请求他人信息
// *
// *  @param otherID 自己的用户信息 填写otherID 则为nil
// *  @param block
// */
//- (void)requestMemberInfoWithOtherID:(NSString *)otherID completionBlock:(ReceiveMenberInfoBlock)block;

@end

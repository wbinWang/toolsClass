//
//  WBRequestManager.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/16.
//  Copyright © 2016年 chenyue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**请求响应的回调*/
typedef void(^ReceiveBlock)(NSDictionary *receiveData);

@interface WBRequestManager : NSObject

+ (WBRequestManager *)shareManager;

#pragma mark - 新的网络地址去请求
/**带参数的网络请求 POST*/
- (void)newPOSTRequestWithParameter:(NSDictionary *)parameter urlString:(NSString *)subAddress andResultBlock:(ReceiveBlock)receiveBlock;
/**网络请求 GET*/
- (void)newGETRequestWithParameter:(NSDictionary *)parameter urlString:(NSString *)subAddress andResultBlock:(ReceiveBlock)receiveBlock;

//#pragma mark - 取消请求
//- (void)cancelRequestTaskWithParameter:(NSDictionary *)parameter urlString:(NSString *)subAddress withMethod:(NSString *)method;

#pragma mark - 同步请求
/**
 *  同步请求方法
 *
 *  @param method     @"POST" / @"GET"
 *  @param parameter  <#parameter description#>
 *  @param subAddress <#subAddress description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)synchronizationRequstWithMethod:(NSString *)method Parameter:(NSDictionary *)parameter urlString:(NSString *)address;

@end

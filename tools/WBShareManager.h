//
//  WBShareManager.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/27.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
@interface WBShareManager : NSObject

+ (WBShareManager *)defaultManager;

@property (nonatomic , assign)WBShareType _lastSharePath;

@property (nonatomic , assign)BOOL weixin;
@property (nonatomic , assign)BOOL weixinFriend;
@property (nonatomic , assign)BOOL weibo;
@property (nonatomic , assign)BOOL qqShare;

#pragma mark - 直播分享
/**
 *  分享直播
 */
//- (void)liveShareType:(WBShareType)type roomID:(NSNumber *)roomID playerName:(NSString *)name playerAvatarImgUrl:(NSString *)imgUrl;

#pragma mark - 分享文字
/**分享到微信聊天 分享全地址、分享内容、分享的缩略图*/
- (void)weixinChatWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl;
/**分享到微信朋友圈 分享全地址、分享内容、分享的缩略图*/
- (void)weixinFriendWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl;
/**微博分享 分享全地址、分享内容、分享的缩略图*/
- (void)weiboWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl;
/**
 *  qq分享
 */
- (void)qqWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl;
/**
 *  qq 空间分享
 */
- (void)qqZoneWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl;

//#pragma mark - 分享图片
///**分享图片到微信*/
//- (void)weixinChatWithContentImage:(UIImage *)img title:(NSString *)title image:(NSURL *)imgUrl;
///**分享图片到朋友圈*/
//- (void)weixinFriendWithContentImage:(UIImage *)img title:(NSString *)title image:(NSURL *)imgUrl;
///**分享图片到微博*/
//- (void)weiboWithContentImage:(UIImage *)img title:(NSString *)title;
///**分享图片到qq*/
//- (void)qqShareWithImage:(UIImage *)img info:(NSString *)info;

/**
 *  分享成功后，给后台一个通知
 */
+ (void)shareSucceed;

/**
 *  返回自己星座的三个关键词
 */
//- (NSString *)selfStarKeyword;

//- (void)writeTopicWordInPlist;

@end

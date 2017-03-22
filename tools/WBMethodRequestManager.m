//
//  WBMethodRequestManager.m
//  ComradeUncle
//
//  Created by wenbin on 16/6/25.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "WBMethodRequestManager.h"
@implementation WBMethodRequestManager
+ (WBMethodRequestManager *)shareManger
{
    static WBMethodRequestManager *manager;
    if (!manager) {
        manager = [[WBMethodRequestManager alloc]init];
    }
    return manager;
}
#pragma mark - 关注
- (void)attentionColumn:(NSNumber *)columnID completionBlock:(ReceiveBlock)block
{
    if (!columnID || ![[kUserDefaults objectForKey:kSelfGuid] length]) {
        WBLog(@"用户ID错误");
        [kNotiDefault postNotificationName:kUserNeedShowLogin object:nil];
        return;
    }
    NSDictionary *dict = @{@"userid":[kUserDefaults objectForKey:kSelfGuid],
                           @"column":columnID};
    [self newPOSTRequestWithParameter:dict urlString:@"usersubscriber" andResultBlock:^(NSDictionary *receiveData) {
        if (block) {
            block(receiveData);
        }
    }];
}
- (void)unAttentionColumn:(NSNumber *)columnID completionBlock:(ReceiveBlock)block
{
    if (!columnID || ![[kUserDefaults objectForKey:kSelfGuid] length]) {
        WBLog(@"用户ID错误");
        [kNotiDefault postNotificationName:kUserNeedShowLogin object:nil];
        return;
    }
    NSDictionary *dict = @{@"userid":[kUserDefaults objectForKey:kSelfGuid],
                           @"column":columnID};
    [self newPOSTRequestWithParameter:dict urlString:@"usersubscribercancel" andResultBlock:^(NSDictionary *receiveData) {
        if (block) {
            block(receiveData);
        }
    }];
}

#pragma mark - 喜欢
- (void)likeWithId:(NSNumber *)oId withType:(WBMainModelType)type completionBlock:(ReceiveBlock)block
{
    //点赞：submitLove POST 参数：userid（用户GUID），id（视频或文章的资源ID）type（资源类型：video / article/ funding）
    if (![[kUserDefaults objectForKey:kSelfGuid] length]) {
        WBLog(@"用户ID错误");
        [kNotiDefault postNotificationName:kUserNeedShowLogin object:nil];
        return;
    }
    NSString *typeStr;
    switch (type) {
        case WBMainModelVideo:
            typeStr = @"video";
            break;
        case WBMainModelArticle:
            typeStr = @"article";
            break;
        case WBMainModelFunding:
            typeStr = @"funding";
            break;
        default:
            break;
    }
    NSDictionary *dict = @{@"userid":[kUserDefaults objectForKey:kSelfGuid],
                           @"id":oId,
                           @"type":typeStr};
    [self newPOSTRequestWithParameter:dict urlString:@"submitlove" andResultBlock:^(NSDictionary *receiveData) {
        if (block) {
            block(receiveData);
        }
    }];
}

//- (void)requestMemberInfoWithcolumnID:(NSString *)columnID completionBlock:(ReceiveMenberInfoBlock)block
//{
//    NSDictionary *parm;
//    /*
//     guid : ad56e51182a776d5378bcd27d0215cca //用户GUID
//     token :    //用户验证token，如果非获取本人资料，token为空
//     curr_guid : ad56e51182a776d5378bcd27d0215cca //当前用户GUID
//     */
//    if (!columnID || !columnID.length) {
//        WBSelfInfoModel *infoModle = [PathAPI getSelfInfoModel];
//        parm = @{@"guid":[kUserDefaults objectForKey:kSelfGuid],
//                 @"token":infoModle.token,
//                 @"curr_guid":[kUserDefaults objectForKey:kSelfGuid]};
//    }else {
//        parm = @{@"guid":columnID,
//                 @"token":@"",
//                 @"curr_guid":[kUserDefaults objectForKey:kSelfGuid]};
//    }
//    [self newPOSTRequestWithParameter:parm urlString:@"getuserprofile" andResultBlock:^(NSDictionary *receiveData) {
//        if ([receiveData[@"ret"] intValue] == 0) {
//            WBSelfInfoModel *model = [WBSelfInfoModel ModelWithDict:receiveData[@"data"]];
//            if (block) {
//                if (!columnID || !columnID.length) {
//                    if (receiveData[@"version"]) {
//                        model.version = receiveData[@"version"];
//                    }
//                    if (receiveData[@"imposed_update"]) {
//                        model.imposed_update = receiveData[@"imposed_update"];
//                    }
//                    if (receiveData[@"game_config"]) {
//                        //游戏时间配置
//                        WBAppConfigModel *config = [WBAppConfigModel shareConfig];
//                        config.gameShowCardTime = receiveData[@"game_config"][@"gameShowCardTime"];
//                        config.gameShowResultTime = receiveData[@"game_config"][@"gameShowResultTime"];
//                        config.gameTimeout = receiveData[@"game_config"][@"gameTimeout"];
//                    }
//                    if (receiveData[@"adpic"]) {
//                        model.adpic = receiveData[@"adpic"];
//                        [self handleADImage:model.adpic];
//                    }
//                }
//                block(model);
//            }
//        }else {
//            if (block) {
//                block(nil);
//            }
//        }
//    }];
//}
/**
 * 处理缓存图片
 */
//- (void)handleADImage:(NSString *)newImgUrl
//{
//    NSString *oldADimgUrl = [kUserDefaults objectForKey:kADImageUrl];
//    
//    if (newImgUrl.length) {
//        //新地址来了
//        if (oldADimgUrl) {
//            //清除旧图片
//            [[SDImageCache sharedImageCache]removeImageForKey:oldADimgUrl withCompletion:^{
//                WBLog(@"adimg 删除成功");
//            }];
//        }
//        //下载新图片地址
//        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:newImgUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            WBLog(@"adimg SDImageCacheType %ld",cacheType);
//        }];
//        //缓存新的图片地址到本地
//        [kUserDefaults setObject:newImgUrl forKey:kADImageUrl];
//        [kUserDefaults synchronize];
//    }else {
//        //新图片长度为0，表示去掉广告页面
//        if (oldADimgUrl) {
//            //此时存在就图片
//            //删除图片
//            [[SDImageCache sharedImageCache]removeImageForKey:oldADimgUrl withCompletion:^{
//                WBLog(@"adimg 删除成功");
//            }];
//            //清楚本地
//            [kUserDefaults setObject:nil forKey:kADImageUrl];
//            [kUserDefaults synchronize];
//        }
//    }
//}
@end

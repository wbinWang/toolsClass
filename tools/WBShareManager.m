//
//  WBShareManager.m
//  ComradeUncle
//
//  Created by wenbin on 16/6/27.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "WBShareManager.h"
@implementation WBShareManager

+ (WBShareManager *)defaultManager
{
    static WBShareManager *manager;
    if (!manager) {
        manager = [[WBShareManager alloc]init];
    }
    return manager;
}
#pragma mark - 微信
//分享到朋友圈或者微信好友的内容
- (void)weixinScene:(int)scene title:(NSString *)info image:(NSURL *)imgUrl shareUrl:(id)shareStr
{
    info = [NSString stringWithFormat:@"%@|黑马柒伍零",info];
    WXMediaMessage *message = [WXMediaMessage message];
    if (scene == 0) {
        //聊天页面
        message.title = @"来自黑马柒伍零的分享";
        message.description = info;
    }else if (scene == 1){
        //朋友圈
        message.title = info;
    }
    UIImage *image;
    if (imgUrl) {
        image = [[SDImageCache sharedImageCache]imageFromCacheForKey:imgUrl.absoluteString];
        image = [toolsClass scaleToSize:image size:CGSizeMake(150, 150)];
        image = [toolsClass composeImgBackImg:image withBackFrame:CGRectMake(0, 0, 150, 150) withFrontImg:[UIImage imageNamed:@"showBigPlayBtn"] withFrontFrame:CGRectMake(30, 30, 90, 90)];
        
    }
    if (!image || !imgUrl) {
        image = [UIImage imageNamed:@"logo"];
    }
    if ([shareStr isKindOfClass:[UIImage class]]) {
        UIImage *tempImg = (UIImage *)shareStr;
        WBLog(@"%f %f",tempImg.size.width , tempImg.size.height);
        image = [toolsClass scaleToSize:tempImg size:CGSizeMake(tempImg.size.width / 2.0, tempImg.size.height / 2.0)];
    }
    [message setThumbImage:image];
    //分享类型
    if ([shareStr isKindOfClass:[NSString class]]) {
        //文字
        WXWebpageObject *ext = [WXWebpageObject object];
        //分享的地址
        ext.webpageUrl = shareStr;
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    }else if ([shareStr isKindOfClass:[UIImage class]]) {
        //图片
        WXImageObject *ext = [WXImageObject object];
        //分享的地址
        UIImage *tempImg = (UIImage *)shareStr;
        NSData *tempData = UIImagePNGRepresentation(tempImg);
        if (tempData.length > 10 * 1024 * 1024) {
            //97484  101,030 字节
            tempData = UIImageJPEGRepresentation(tempImg, 0.8);
        }
        WBLog(@"图片所占大小 %lu",(unsigned long)tempData.length);
        
        ext.imageData = tempData;
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    }
    
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"说点什么吧";
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    BOOL shareSuccess = [WXApi sendReq:req];
    WBLog(@"分享成功与否 %d",shareSuccess);
}
/**分享到微信聊天*/
- (void)weixinChatWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl
{
    [self weixinScene:0 title:title image:imgUrl shareUrl:url];
}
/**分享到微信朋友圈*/
- (void)weixinFriendWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl
{
    [self weixinScene:1 title:title image:imgUrl shareUrl:url];
}
#pragma mark - 分享图片
/**分享到微信聊天 分享全地址、分享内容、分享的缩略图*/
- (void)weixinChatWithContentImage:(UIImage *)img title:(NSString *)title image:(NSURL *)imgUrl
{
    [self weixinScene:0 title:title image:imgUrl shareUrl:img];
}
/**分享到微信朋友圈 分享全地址、分享内容、分享的缩略图*/
- (void)weixinFriendWithContentImage:(UIImage *)img title:(NSString *)title image:(NSURL *)imgUrl
{
    [self weixinScene:1 title:title image:imgUrl shareUrl:img];
}


#pragma mark - 微博分享
/**微博分享*/
- (void)weiboWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *msgObj = [self messageToShareContentUrl:url title:title image:imgUrl];
    
    WBSendMessageToWeiboRequest *request =
    [WBSendMessageToWeiboRequest requestWithMessage:msgObj
                                           authInfo:authRequest
                                       access_token:[kUserDefaults objectForKey:kWeiboToken]];
    
    request.userInfo = @{@"ShareMessageFrom": @"WBShareManager",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};

    [WeiboSDK sendRequest:request];
}
- (void)weiboWithContentImage:(UIImage *)img title:(NSString *)title
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShareContentUrl:@"" title:title image:img] authInfo:authRequest access_token:[[NSUserDefaults standardUserDefaults] objectForKey:kWeiboToken]];
    
    request.userInfo = @{@"ShareMessageFrom": @"WBShareManager",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}
//获取微博认证
- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"WBShareManager",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}
/**
 * 微博 分享 图片
 */
- (WBMessageObject *)messageToShareContentUrl:(NSString *)url title:(NSString *)title image:(id)imgOrUrl
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = [NSString stringWithFormat:@"%@ %@",title,url];
    
    WBWebpageObject *webObj = [WBWebpageObject object];
    webObj.webpageUrl = imgOrUrl;
    
    WBImageObject *imageObj = [WBImageObject object];
    
    UIImage *image;
    if ([imgOrUrl isKindOfClass:[NSURL class]]) {
        NSURL *imgUrl = (NSURL *)imgOrUrl;
        image = [[SDImageCache sharedImageCache]imageFromCacheForKey:imgUrl.absoluteString];
        image = [toolsClass scaleToSize:image size:CGSizeMake(150, 150)];
        image = [toolsClass composeImgBackImg:image withBackFrame:CGRectMake(0, 0, 150, 150) withFrontImg:[UIImage imageNamed:@"showBigPlayBtn"] withFrontFrame:CGRectMake(30, 30, 90, 90)];
        
    }else if ([imgOrUrl isKindOfClass:[UIImage class]]) {
        image = imgOrUrl;
    }
    if (!image || !imgOrUrl) {
        image = [UIImage imageNamed:@"logo"];
    }
    
    imageObj.imageData = UIImageJPEGRepresentation(image, 1);
    message.imageObject = imageObj;

    return message;
}
/**
 * 微博分享 url 直播里面分享
 */
- (WBMessageObject *)weiboShareUrl:(NSString *)contentUrl title:(NSString *)title avatar:(NSString *)avatar
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webObj = [WBWebpageObject object];
    webObj.webpageUrl = contentUrl;
    webObj.title = title;
    webObj.objectID = @"001";
    
    UIImage *thumbImg = [[SDImageCache sharedImageCache]imageFromCacheForKey:[NSURL URLWithString:avatar accordingToWidth:kLittleAvatarW].absoluteString];
    if (!thumbImg) {
        thumbImg = [UIImage imageNamed:@"logo"];
    }
    webObj.thumbnailData = UIImageJPEGRepresentation(thumbImg, 0.5);
    message.mediaObject = webObj;
    
    return message;
}
#pragma mark - QQ
////qq分享图片
//- (void)qqShareWithImage:(UIImage *)img info:(NSString *)info
//{
//    NSData *imgData = UIImagePNGRepresentation(img);
//    NSData *previewData = UIImageJPEGRepresentation(img, 0.2);
//    
//    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
//                                               previewImageData:previewData
//                                                          title:@"酷熊星球"
//                                                    description:info];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
//    //将内容分享到qq
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//    WBLog(@"qq 分享 %d",sent);
//}
- (void)qqShareContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl isZone:(BOOL)isZ
{
    UIImage *image;
    if (imgUrl) {
        image = [[SDImageCache sharedImageCache]imageFromCacheForKey:imgUrl.absoluteString];
        image = [toolsClass scaleToSize:image size:CGSizeMake(150, 150)];
        image = [toolsClass composeImgBackImg:image withBackFrame:CGRectMake(0, 0, 150, 150) withFrontImg:[UIImage imageNamed:@"showBigPlayBtn"] withFrontFrame:CGRectMake(30, 30, 90, 90)];
    }
    if (!image || !imgUrl) {
        image = [UIImage imageNamed:@"logo"];
    }
    title = [NSString stringWithFormat:@"%@|黑马七五零",title];
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                        title:@"黑马柒伍零"
                                                  description:title
                                             previewImageData:UIImagePNGRepresentation(image)];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (!isZ) {
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        WBLog(@"qq 分享 %d",sent);
    }else {
        //分享到zone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        WBLog(@"qq zone 分享 %d",sent);
    }
}
/**
 *  qq分享
 */
- (void)qqWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl
{
    [self qqShareContentUrl:url title:title image:imgUrl isZone:NO];
}
/**
 *  qq 空间分享
 */
- (void)qqZoneWithContentUrl:(NSString *)url title:(NSString *)title image:(NSURL *)imgUrl
{
    [self qqShareContentUrl:url title:title image:imgUrl isZone:YES];
}
#pragma mark - 给自己系统发个消息
+ (void)shareSucceed
{
//    WBSelfInfoModel *infoModel = [PathAPI getSelfInfoModel];
//    NSDictionary *DICT = @{@"guid":infoModel.guid,
//                           @"token":infoModel.token};
//    [[WBRequestManager shareManager] newPOSTRequestWithParameter:DICT urlString:@"submitshare" andResultBlock:^(NSDictionary *receiveData) {
//        
//    }];
}
//#pragma mark - 分享文字解析
//- (void)writeInPlist
//{
//    //1. 创建一个plist文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path2 = [paths objectAtIndex:0];
//    NSString *path = [path2 stringByAppendingPathComponent:@"shareWord.plist"];
//    
//    NSLog(@"path = %@",path);
//    
//    //创建一个dic，写到plist文件里
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSString *totalString = @"白羊座：善解人衣、顺毛就乖、老子最酷、傻白美甜、热情似火、好打鸡血、性致勃勃、以德报怨、说飞就飞、充满活力、不留余地。金牛座：今我有钱、哪里打折、先吃再说、物质主义、永不认错、闷声发财、美食至上、稳重闷骚、多才多艺、稳重务实、意志坚定。双子座：来者不拒、目中无人、社交之神、既往不恋、假装洒脱、花式分裂、完美搭配、八卦源头、天生演员、八面玲珑、知道进退。巨蟹座：患得患失、暖气十足、居家必备、母性至上、资深绿茶、无微不至、比妈还亲、玻璃心脏、大智若愚、不善社交、有正义感。狮子座：就是霸气、夸我别停、再来一发、帅破天际、天生王者、英勇无畏、绝对服从、慷慨仗义、不炫会死、自信自强、气度不凡。处女座：必须完美、我嘴有毒、软硬不吃、完美主义、优柔寡断、事儿奶奶、吹毛求疵、当代唐僧、智商超群、善于分析、尽善尽美。天秤座：漂亮就行、人见人爱、颜值担当、能屈能伸、外貌协会、当断不断、亲善大使、左右摇摆、社交专家、谈吐得体、缺乏自信。天蝎座：非黑即白、爱我别跑、今晚还要、不服单挑、精力超群、虐人不倦、有仇必报、皮鞭蜡烛、神秘高冷、恩怨分明、态度明确。射手座：二得有范、来者不拒、大爱无疆、天生多情、英熊情结、资深爱神、闺蜜成群、热爱自由、像个孩子、内心纯良、盲目乐观。摩羯座：奋斗到底、高冷无害、心有猛虎、人艰不拆、累觉不爱、只想加班、生人勿进、面若冰霜、懒得理你、被动慢热、忍者神龟。水瓶座：药不能停、绝版限量、独一无二、外来物种、难以捉摸、凡人闭嘴、冷笑话王、天马行空、阴晴不定、思想超前、破喜被虐。双鱼座：玻璃公举、矫情一逼、内心影帝、没事找事、爱个不停、活在梦里、假笑专家、圣母附体、智商成迷、心思细腻、憧憬浪漫";
//    NSArray *array1 = [totalString componentsSeparatedByString:@"。"];
//    
//    for (int i = 0; i < array1.count; i++) {
//        NSString *sub = array1[i];
//        //白羊座：善解人衣  顺毛就乖  老子最酷  傻白美甜、热情似火  好打鸡血  性致勃勃  以德报怨、说飞就飞  充满活力  不留余地
//        NSString *name = [[sub componentsSeparatedByString:@"："] firstObject];
//        NSString *content = [[sub componentsSeparatedByString:@"："] lastObject];
//        NSArray *arr = [content componentsSeparatedByString:@"、"];
//        [dict setObject:arr forKey:name];
//    }
//    WBLog(@"%@",dict);
//    
//    BOOL isSuccess = [dict writeToFile:path atomically:YES];    
//}
//#pragma mark - 星座鉴定礼物文字解析
//- (void)writeStarIdentifyGiftWordInPlist
//{
//    //1. 创建一个plist文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path2 = [paths objectAtIndex:0];
//    NSString *path = [path2 stringByAppendingPathComponent:@"StarIdentifyGiftWord.plist"];
//    
//    NSLog(@"path = %@",path);
//    
//    //创建一个dic，写到plist文件里
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSString *totalString = @"蛇夫座：谜一般的星座、主播没填星座、可能很懒、可能很忙、可能戒备心很强、让主播重新填星座、谜谜谜谜...、检定仪故障...、可能是十三星座？、 神秘的蛇夫座？、啥也没鉴定出来。白羊座：善解人衣、顺毛就乖、老子最酷、傻白美甜、热情似火、好打鸡血、性致勃勃、以德报怨、说飞就飞、充满活力、不留余地、自行其事、速战速决、瞻前不顾后、没耐心、孩子气、说话欠考虑、乐观活泼、三分钟热度、接受新观念、好胜独立、正能量长满、买买买、自恋。金牛座：今我有钱、哪里打折、先吃再说、物质主义、永不认错、闷声发财、美食至上、稳重闷骚、多才多艺、稳重务实、意志坚定、钱、固执、怕改变、慢性子、有艺术细胞、闷骚、有主见、有计划、生活有规律、守秩序、占有欲强、过于严肃、我就看看不吃、守财奴葛朗台。双子座：来者不拒、目中无人、社交之神、既往不恋、假装洒脱、花式分裂、完美搭配、八卦源头、天生演员、八面玲珑、知道进退、人格分裂、偏爱新鲜、有分寸、不喜欢被束缚、鬼点子多、飘忽不定、花心、反应灵敏、话唠、善变、情绪起伏大、多动症、宇宙最机智、富华的外表。巨蟹座：患得患失、暖气十足、居家必备、母性至上、资深绿茶、无微不至、比妈还亲、玻璃心脏、大智若愚、不善社交、有正义感、缺乏安全感、敏感、善良、感知力强、顾虑多、易满足、有艺术天赋、特别能作、孝顺、狂爱禁断恋、偷窥狂、绝对演技派、可怕洞察力、悲天悯人。狮子座：就是霸气、夸我别停、再来一发、帅破天际、天生王者、英勇无畏、绝对服从、慷慨仗义、不炫会死、自信自强、气度不凡、光明磊落、尊严、王者、真爱秒变猫、不熟高冷逼、控制欲强、热情、不多疑、面子、好管闲事、怕寂寞、善于各种炫、就像一把火、永远热血。处女座：必须完美、我嘴有毒、软硬不吃、完美主义、优柔寡断、事儿奶奶、吹毛求疵、当代唐僧、智商超群、善于分析、尽善尽美、月饼界的五仁、龟毛、洁癖强迫症、自恋、鸡蛋挑骨头、重秩序、谨慎、自我要求严、精明、有耐心、处事小心、事儿妈、毒舌是隐、越挫越勇。天秤座：漂亮就行、人见人爱、颜值担当、能屈能伸、外貌协会、当断不断、亲善大使、左右摇摆、社交专家、谈吐得体、缺乏自信、社交能力强、颜控、精神伴侣、懂享受、不喜欢决定、选择恐惧症、天生优雅、爱装傻、时常想多、察言观色、理想主义者、时尚的主宰、绝对自恋。天蝎座：非黑即白、爱我别跑、今晚还要、不服单挑、精力超群、虐人不倦、有仇必报、皮鞭蜡烛、神秘高冷、恩怨分明、态度明确、自我要求高、会洞察别人、讲义气、能保守秘密、有欲望、低调、报复心强、伪装自己、极端自我、性感、深谋远虑、冷漠、学霸、动不动玩消失、善妒。射手座：二得有范、来者不拒、大爱无疆、天生多情、英熊情结、资深爱神、闺蜜成群、热爱自由、像个孩子、内心纯良、盲目乐观、反应快、过度理想化、备胎多、自由、经得起打击、会伤人、有挑战精神、创造力强、喜怒形于色、谦和、怕无聊、不听劝、热情、买买买、冒险家。摩羯座：奋斗到底、高冷无害、心有猛虎、人艰不拆、累觉不爱、只想加班、生人勿进、面若冰霜、懒得理你、被动慢热、忍者神龟、木头人、内心戏、闷骚狗、玻璃心、悲观病、高冷帝、演技派、专一神、我就憋着不说话、孤独症晚期、离经叛道、一本正经、责任感、小小偏执狂。水瓶座：药不能停、绝版限量、独一无二、外来物种、难以捉摸、凡人闭嘴、冷笑话王、天马行空、阴晴不定、思想超前、破喜被虐、三分钟热度、天天更年期、明骚、博爱、敏锐、个性独特、不属于地球、求知欲强、幽默诙谐、善于沟通、注重隐私、最高等级怪咖、心有乌托邦。双鱼座：玻璃公举、矫情一逼、内心影帝、没事找事、爱个不停、活在梦里、假笑专家、圣母附体、智商成迷、心思细腻、憧憬浪漫、最难评价的星座、会玩、悲观、怕失去、不懂得独立、多情、幻想家、爱憧憬、直觉准、对人亲和、好辩、不够果断、行动力差、恋物狂";
//    NSArray *array1 = [totalString componentsSeparatedByString:@"。"];
//    
//    for (int i = 0; i < array1.count; i++) {
//        NSString *sub = array1[i];
//        //白羊座：善解人衣  顺毛就乖  老子最酷  傻白美甜、热情似火  好打鸡血  性致勃勃  以德报怨、说飞就飞  充满活力  不留余地
//        NSString *name = [[sub componentsSeparatedByString:@"："] firstObject];
//        NSString *content = [[sub componentsSeparatedByString:@"："] lastObject];
//        NSArray *arr = [content componentsSeparatedByString:@"、"];
//        [dict setObject:arr forKey:name];
//    }
//    WBLog(@"%@",dict);
//    
//    BOOL isSuccess = [dict writeToFile:path atomically:YES];
//}
//
//- (NSString *)selfStarKeyword
//{
//    NSDictionary *totalDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareWord" ofType:@"plist"]];
//    WBSelfInfoModel *infoModel = [PathAPI getSelfInfoModel];
//    NSInteger xx = 0;
//    if ([infoModel.starsign integerValue] > 0) {
//        xx = [infoModel.starsign integerValue] - 1;
//    }
//    NSString *selfStar = [kConstellationArray objectAtIndex:xx];
//    
//    NSMutableArray *keywords = [NSMutableArray arrayWithArray:totalDict[selfStar]];
//    NSMutableArray *selcetKey = [NSMutableArray array];
//    for (int i = 0; i < 1; i++) {
//        int xx = arc4random_uniform((int)keywords.count);
//        NSString *str = keywords[xx];
//        
//        [selcetKey addObject:str];
//        [keywords removeObject:str];
//    }
//    NSString *retureStr = [selcetKey componentsJoinedByString:@"、"];
//    
//    return [retureStr stringByAppendingFormat:@"的%@",selfStar];
//}
//
///*
// 白羊座：善解人衣  顺毛就乖  老子最酷  傻白美甜、热情似火  好打鸡血  性致勃勃  以德报怨、说飞就飞  充满活力  不留余地。金牛座：今我有钱  哪里打折  先吃再说、物质主义  永不认错  闷声发财  美食至上、稳重闷骚  多才多艺  稳重务实  意志坚定。双子座：来者不拒  目中无人  社交之神  既往不恋  假装洒脱  花式分裂  完美搭配  八卦源头  天生演员  八面玲珑  知道进退。巨蟹座：患得患失  暖气十足  居家必备  母性至上  资深绿茶  无微不至  比妈还亲、玻璃心脏  大智若愚  不善社交  有正义感。狮子座：就是霸气  夸我别停  再来一发  帅破天际  天生王者  英勇无畏  绝对服从、慷慨仗义  不炫会死  自信自强  气度不凡。处女座：必须完美  我嘴有毒  软硬不吃  完美主义、优柔寡断  事儿奶奶  吹毛求疵  当代唐僧  智商超群、善于分析  尽善尽美。天秤座：漂亮就行  人见人爱  颜值担当  能屈能伸、外貌协会  当断不断  亲善大使  左右摇摆、社交专家  谈吐得体  缺乏自信。天蝎座：非黑即白  爱我别跑  今晚还要  不服单挑、精力超群  虐人不倦  有仇必报  皮鞭蜡烛、神秘高冷  恩怨分明  态度明确。射手座：二得有范  来者不拒  大爱无疆  天生多情、英熊情结  资深爱神、闺蜜成群、热爱自由  像个孩子  内心纯良  盲目乐观。摩羯座：奋斗到底  高冷无害  心有猛虎  人艰不拆  累觉不爱  只想加班  生人勿进  面若冰霜  懒得理你、被动慢热  忍者神龟。水瓶座：药不能停  绝版限量  独一无二  外来物种  难以捉摸  凡人闭嘴、冷笑话王  天马行空  阴晴不定  思想超前  破喜被虐。双鱼座：玻璃公举  矫情一逼  内心影帝  没事找事  爱个不停、活在梦里  假笑专家  圣母附体  智商成迷、心思细腻  憧憬浪漫
// */
///*
// 拍离你最近的一个萌妹子、试试用舌头舔到胳膊肘、试试用舌头舔到鼻子尖儿、拍拍你最喜欢的一双鞋、秀一下你与人不同的才艺、往左转三圈，再往右转三圈√、来讲一个笑话吧、用最华丽的语言来夸夸自己、背一首你最熟的唐诗、展现下你最美的笑容和最难过的样子、表演一下什么叫狼吞虎咽、模仿一个你喜欢的影视角色、唱几句你最拿手的歌、说说你遇到过的最扣的人、说说你买过的最失败的东西、说说你见过的最奇葩的人名、分享下你觉得最值得去旅游的地方、谈谈你最想做的工作、扒一扒你见过最心机的绿茶婊、说件你做过的最大胆的事儿、说件最让你感动的事儿、给大家推荐一部你喜欢的剧吧、说说你印象最深的一次撕逼、推荐几个你喜欢吃的零食、说说你最长的一次暗恋、说说令你印象最深的自我介绍、说一句你喜欢的一句歌词、说说你印象最深的一句电影台词、推荐几部你觉得最值得看的电影、说说你看过的最烂的电影、说说你买过的最物有所值的东西、说一说你最喜欢的酷熊女主播、你最喜欢酷熊的哪位主播？、分享下最近你在淘宝买的好吃的、分享下你独特的美食搭配经验、分享下你一直坚持的好习惯、说说你最欣赏的演员、说说男人拍照怎么摆pose好、分享一下你撩妹或者撩汉的技巧、分享一下成功的减肥方法、分享下你印象最深的广告、分享几句直戳心底的负能量的话、分享一件小时候最尴尬的事儿、分享下你见过哪些黑暗料理、吐槽下你认识妈宝男或凤凰男、你打死都不会和哪个星座谈恋爱？、你觉得哪个星座的人最难追？、你用一句话逼疯哪个星座？、哪个星座是撩汉/撩妹高手？、你觉得哪个星座的人最善变？、你觉得什么是代沟？、你觉得哪个星座的人异性缘最好？、你觉得哪个星座的人最疼人？、和喜欢的人星座不合，你还会继续吗？、你觉得哪个星座的人最固执？、你觉得哪个星座的人最念旧？、你觉得和哪个星座的人最不好相处？、说说你了解的金牛座、说说你了解的射手座、说说你了解的狮子座、说说你了解的巨蟹座、说说你了解的双子座、说说你了解的白羊座、说说你了解的天蝎座、说说你了解的摩羯座、说说你了解的处女座、说说你了解的天秤座、说说你了解的水瓶座、情侣性格是互补好还是相近好？、你朋友圈屏蔽父母了吗？、下辈子你想当男生还是女生？、你见过的最搞笑的网名是什么？、你做过的最奇怪的梦是什么？、你用过最坑人的软件是？、你觉得男女之间会有纯友谊么？、中国你最喜欢哪些城市？、如果明天是世界末日，你会做什么？、如果可以穿越，你最想去哪个朝代？、分手后会有什么反应？、最无法忍受另一半的什么行为？、说说你去过的最美的地方是哪里、你在外面玩过通宵吗？、女生怎么调戏男生才显得高端？、出国留学的意义是什么？、你觉得旅行的意义是什么？、你觉得人为什么要结婚？、说说你用过什么表白的方式？、你遇到过善意的谎言吗？、聊天找不到话题怎么办？、女神和绿茶婊有什么区别？、你听过的最让人绝望的话是什么？、女孩要富养，男孩要穷养是对的吗？、什么样的男生会让你觉得很娘？、你觉得胖子穿什么衣服才好看？、你最容易因为哪些问题而生气？、你觉得同性恋分手会用什么理由？、如果你会瞬间移动，你会干什么？、你觉得为什么大家喜欢黑处女座？、节假日你喜欢宅在家还是出门玩？、周末你一般都做什么？、你坚持最久的一个爱好是什么？、你觉得哪个省最盛产美女？、你眼中最美好的生活是什么样的？、你会先爱上对方的身体还是灵魂？、你觉得什么才是安全感？、你觉得事业重要还是爱情重要？、有什么菜让你百吃不腻？、洗完澡你会先穿上衣还是裤子？、你觉得真的是一分价钱一分货吗？、你喜欢小鲜肉还是大叔？、你被起过什么特别的昵称？、你喜欢看电子书还是纸质的书？、你觉得有哪些大道理是明显错误的？、你觉得性格会决定命运吗？、你有制订新一年的计划吗？、你在纠结的时候会怎么办？、你会不会突然有什么新奇的想法？、什么事情你一直想做又不敢做？、你给朋友送过什么比较特别的礼物？、你喜欢素颜还是化妆？、你对整容有什么看法？、你觉得脸大有什么好处？、你觉得平胸有什么好处？、你觉得女生一定要会化妆么？、你喜欢什么颜色的衣服搭配？、睡觉前饿了，你会吃东西还是去睡觉？、你谈恋爱会在乎年龄的差距么？、你最爱吃什么火锅小料？、如果上厕所时没带纸你会怎么办？、如果一辈子单身会很难过吗？、你最爱听什么假话？、你会一个人去吃自助餐吗？、大胸是怎样的体验？、你会吃回头草么？、你都买过什么没用的东西？、化妆前后差距大么？、怎么看待男闺蜜？、你觉得什么才是家？、你有过说走就走的旅行么？、你怎么看待网红脸？、你觉得人体哪个部位构造不够科学？、恋爱中你喜欢主动还是被动？、说说你为哪个电影桥段流泪过？、你喜欢长发还是短发的女孩？、你会告诉伴侣你的手机密码么？、你觉得相处时间长了会日久生情么？、女生说肚子疼应该怎么回复？、你最希望学习什么技能？、你还记得高中数学都学了什么吗？、你还记得小学语文的哪些课文？、你第一次熬通宵是为了做什么？、怎么区分喜欢ta还是想睡ta？、你觉得老实人是褒义词还是贬义词？、每年春节你最期待什么？、每年春节你最怕什么？、你最难抵御的诱惑是什么？、另一半太强你会没有安全感么？、你还记得因为什么被揍过么？、你会找一个比你强的女朋友吗？、什么时候你会有被掏空的感觉？、你觉得旅行有什么意义？、你最近在看什么动画或漫画？、推荐一部你正在追的新番吧！、聊聊你最喜欢的小哥哥or小姐姐、有在玩什么手游？推荐一个吧、讲讲你最近氪金最狠的一个游戏、安利一条你最喜欢的小裙子、近年来最喜欢哪部动画or漫画？、唱一段儿PPAP吧、威风？虎视？一骑？一心？疑心？、跟我读：niconiconiconi niconico！、讲讲你最喜欢的nico唱见、讲讲你最喜欢的国人唱见、最喜欢的P站画师是？、最喜欢的国人画师是？、给dalao递茶的正确姿势、胸不平何以平天下的下一句是？、这么可爱一定是(....)(三字中文) 、鸡肉味，嘎嘣脆←这句话出自谁？、看蓝猫，学蓝猫我有什么我自豪？、你最近吃土了么？、土都吃不起了你要怎么活？、你肝阴阳师了么？、敢不敢说你自己是欧洲人？、非酋到底是怎么样一种存在？、大声告诉我你腐不腐？、手还在么，剁没剁？、摸着你的良心说话吃藕不吃藕？、没时间了快上车！、老司机都去哪里了，带带我、渣不渣基三？、你胸大你说话，你说不说？、Lo娘是怎么样一种存在？、Coser的日常是什么？、氪金到底是怎么样一种体验？、哪个大佬让你献出了膝盖？、听什么话会感觉膝盖中了一箭？、哪些人被你记在了小本本上？、最近有没有撸啊撸？、你宅么，长蘑菇了么？、你是不是时常感觉总有刁民想害朕？、你去a站还是b站？、你觉得的二次元到底是个啥？、你最近给别人塞了什么安利？、你最近吃了谁的什么安利？
// */
//#pragma mark - 短视频话题问题
//- (void)writeTopicWordInPlist
//{
//    //1. 创建一个plist文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path2 = [paths objectAtIndex:0];
//    NSString *path = [path2 stringByAppendingPathComponent:@"smallViewTopicWord1.plist"];
//    
//    NSLog(@"path = %@",path);
//    
//    //创建一个dic，写到plist文件里
//    NSString *totalString = @"拍离你最近的一个萌妹子、试试用舌头舔到胳膊肘、试试用舌头舔到鼻子尖儿、拍拍你最喜欢的一双鞋、秀一下你与人不同的才艺、往左转三圈，再往右转三圈√、来讲一个笑话吧、用最华丽的语言来夸夸自己、背一首你最熟的唐诗、展现下你最美的笑容和最难过的样子、表演一下什么叫狼吞虎咽、模仿一个你喜欢的影视角色、唱几句你最拿手的歌、说说你遇到过的最扣的人、说说你买过的最失败的东西、说说你见过的最奇葩的人名、分享下你觉得最值得去旅游的地方、谈谈你最想做的工作、扒一扒你见过最心机的绿茶婊、说件你做过的最大胆的事儿、说件最让你感动的事儿、给大家推荐一部你喜欢的剧吧、说说你印象最深的一次撕逼、推荐几个你喜欢吃的零食、说说你最长的一次暗恋、说说令你印象最深的自我介绍、说一句你喜欢的一句歌词、说说你印象最深的一句电影台词、推荐几部你觉得最值得看的电影、说说你看过的最烂的电影、说说你买过的最物有所值的东西、说一说你最喜欢的酷熊女主播、你最喜欢酷熊的哪位主播？、分享下最近你在淘宝买的好吃的、分享下你独特的美食搭配经验、分享下你一直坚持的好习惯、说说你最欣赏的演员、说说男人拍照怎么摆pose好、分享一下你撩妹或者撩汉的技巧、分享一下成功的减肥方法、分享下你印象最深的广告、分享几句直戳心底的负能量的话、分享一件小时候最尴尬的事儿、分享下你见过哪些黑暗料理、吐槽下你认识妈宝男或凤凰男、你打死都不会和哪个星座谈恋爱？、你觉得哪个星座的人最难追？、你用一句话逼疯哪个星座？、哪个星座是撩汉/撩妹高手？、你觉得哪个星座的人最善变？、你觉得什么是代沟？、你觉得哪个星座的人异性缘最好？、你觉得哪个星座的人最疼人？、和喜欢的人星座不合，你还会继续吗？、你觉得哪个星座的人最固执？、你觉得哪个星座的人最念旧？、你觉得和哪个星座的人最不好相处？、说说你了解的金牛座、说说你了解的射手座、说说你了解的狮子座、说说你了解的巨蟹座、说说你了解的双子座、说说你了解的白羊座、说说你了解的天蝎座、说说你了解的摩羯座、说说你了解的处女座、说说你了解的天秤座、说说你了解的水瓶座、情侣性格是互补好还是相近好？、你朋友圈屏蔽父母了吗？、下辈子你想当男生还是女生？、你见过的最搞笑的网名是什么？、你做过的最奇怪的梦是什么？、你用过最坑人的软件是？、你觉得男女之间会有纯友谊么？、中国你最喜欢哪些城市？、如果明天是世界末日，你会做什么？、如果可以穿越，你最想去哪个朝代？、分手后会有什么反应？、最无法忍受另一半的什么行为？、说说你去过的最美的地方是哪里、你在外面玩过通宵吗？、女生怎么调戏男生才显得高端？、出国留学的意义是什么？、你觉得旅行的意义是什么？、你觉得人为什么要结婚？、说说你用过什么表白的方式？、你遇到过善意的谎言吗？、聊天找不到话题怎么办？、女神和绿茶婊有什么区别？、你听过的最让人绝望的话是什么？、女孩要富养，男孩要穷养是对的吗？、什么样的男生会让你觉得很娘？、你觉得胖子穿什么衣服才好看？、你最容易因为哪些问题而生气？、你觉得同性恋分手会用什么理由？、如果你会瞬间移动，你会干什么？、你觉得为什么大家喜欢黑处女座？、节假日你喜欢宅在家还是出门玩？、周末你一般都做什么？、你坚持最久的一个爱好是什么？、你觉得哪个省最盛产美女？、你眼中最美好的生活是什么样的？、你会先爱上对方的身体还是灵魂？、你觉得什么才是安全感？、你觉得事业重要还是爱情重要？、有什么菜让你百吃不腻？、洗完澡你会先穿上衣还是裤子？、你觉得真的是一分价钱一分货吗？、你喜欢小鲜肉还是大叔？、你被起过什么特别的昵称？、你喜欢看电子书还是纸质的书？、你觉得有哪些大道理是明显错误的？、你觉得性格会决定命运吗？、你有制订新一年的计划吗？、你在纠结的时候会怎么办？、你会不会突然有什么新奇的想法？、什么事情你一直想做又不敢做？、你给朋友送过什么比较特别的礼物？、你喜欢素颜还是化妆？、你对整容有什么看法？、你觉得脸大有什么好处？、你觉得平胸有什么好处？、你觉得女生一定要会化妆么？、你喜欢什么颜色的衣服搭配？、睡觉前饿了，你会吃东西还是去睡觉？、你谈恋爱会在乎年龄的差距么？、你最爱吃什么火锅小料？、如果上厕所时没带纸你会怎么办？、如果一辈子单身会很难过吗？、你最爱听什么假话？、你会一个人去吃自助餐吗？、大胸是怎样的体验？、你会吃回头草么？、你都买过什么没用的东西？、化妆前后差距大么？、怎么看待男闺蜜？、你觉得什么才是家？、你有过说走就走的旅行么？、你怎么看待网红脸？、你觉得人体哪个部位构造不够科学？、恋爱中你喜欢主动还是被动？、说说你为哪个电影桥段流泪过？、你喜欢长发还是短发的女孩？、你会告诉伴侣你的手机密码么？、你觉得相处时间长了会日久生情么？、女生说肚子疼应该怎么回复？、你最希望学习什么技能？、你还记得高中数学都学了什么吗？、你还记得小学语文的哪些课文？、你第一次熬通宵是为了做什么？、怎么区分喜欢ta还是想睡ta？、你觉得老实人是褒义词还是贬义词？、每年春节你最期待什么？、每年春节你最怕什么？、你最难抵御的诱惑是什么？、另一半太强你会没有安全感么？、你还记得因为什么被揍过么？、你会找一个比你强的女朋友吗？、什么时候你会有被掏空的感觉？、你觉得旅行有什么意义？、你最近在看什么动画或漫画？、推荐一部你正在追的新番吧！、聊聊你最喜欢的小哥哥or小姐姐、有在玩什么手游？推荐一个吧、讲讲你最近氪金最狠的一个游戏、安利一条你最喜欢的小裙子、近年来最喜欢哪部动画or漫画？、唱一段儿PPAP吧、威风？虎视？一骑？一心？疑心？、跟我读：niconiconiconi niconico！、讲讲你最喜欢的nico唱见、讲讲你最喜欢的国人唱见、最喜欢的P站画师是？、最喜欢的国人画师是？、给dalao递茶的正确姿势、胸不平何以平天下的下一句是？、这么可爱一定是(....)(三字中文) 、鸡肉味，嘎嘣脆←这句话出自谁？、看蓝猫，学蓝猫我有什么我自豪？、你最近吃土了么？、土都吃不起了你要怎么活？、你肝阴阳师了么？、敢不敢说你自己是欧洲人？、非酋到底是怎么样一种存在？、大声告诉我你腐不腐？、手还在么，剁没剁？、摸着你的良心说话吃藕不吃藕？、没时间了快上车！、老司机都去哪里了，带带我、渣不渣基三？、你胸大你说话，你说不说？、Lo娘是怎么样一种存在？、Coser的日常是什么？、氪金到底是怎么样一种体验？、哪个大佬让你献出了膝盖？、听什么话会感觉膝盖中了一箭？、哪些人被你记在了小本本上？、最近有没有撸啊撸？、你宅么，长蘑菇了么？、你是不是时常感觉总有刁民想害朕？、你去a站还是b站？、你觉得的二次元到底是个啥？、你最近给别人塞了什么安利？、你最近吃了谁的什么安利？";
//    NSArray *array1 = [totalString componentsSeparatedByString:@"、"];
//    WBLog(@"%@",array1);
//    BOOL isSuccess = [array1 writeToFile:path atomically:YES];
//}
//
//#pragma mark - 直播页面的分享
//- (void)liveShareType:(WBShareType)type roomID:(NSNumber *)roomID playerName:(NSString *)name playerAvatarImgUrl:(NSString *)imgUrl
//{
//    WBSelfInfoModel *infoModel = [PathAPI getSelfInfoModel];
//    //分享地址
//    NSString *contentUrl = [NSString stringWithFormat:@"http://www.kuxiongzhibo.com/share.php?room=%@&user=%@",roomID,infoModel.guid];
//    //分享人星座文字
//    NSString *keywords = [[WBShareManager defaultManager] selfStarKeyword];
//    
//    //分享文字
//    NSString *contentLabel;
//    //头像
//    NSString *avatar;
//    if (!name && !imgUrl) {
//        //自己为主播，分享自己的直播时
//        contentLabel = [NSString stringWithFormat:@"%@ %@正在酷熊星球，邀请全宇宙小伙伴速度来酷熊围观！",keywords , infoModel.username];
//        avatar = infoModel.headimg;
//    }else {
//        //分享他人直播
//        contentLabel = [NSString stringWithFormat:@"%@ %@邀请全宇宙小伙伴迅速来围观%@的直播！",keywords , infoModel.username , name];
//        avatar = imgUrl;
//    }
//    if (type == WBShareWXFriend) {
//        
//        [self weixinFriendWithContentUrl:contentUrl title:contentLabel image:avatar];
//    }else if (type == WBShareWeixin) {
//        
//        [self weixinChatWithContentUrl:contentUrl title:contentLabel image:avatar];
//    }else if (type == WBShareWeibo) {
//        
//        [self weiboWithContentUrl:contentUrl title:contentLabel image:avatar];
//    }else if (type == WBShareQQ) {
//        //QQ
//        [self qqShareWithWebUrl:contentUrl contentText:contentLabel avatar:avatar];
//    }
//}

@end

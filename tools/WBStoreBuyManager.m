//
//  WBStoreBuyManager.m
//  ComradeUncle
//
//  Created by wenbin on 16/6/27.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "WBStoreBuyManager.h"
@interface WBStoreBuyManager()
{
    SKProductsRequest *_request;
}
@end

@implementation WBStoreBuyManager
- (instancetype)init
{
    if (self = [super init]) {
        //添加购买进程代理
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
- (void)dealloc
{
    WBLog(@"WBStoreBuyManager dealloc");
    [_request cancel];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
//请求商品
- (void)beginRequstProductsInfo {
    
    //kSHOW_LOADING;
    NSArray *product = @[@"com.kuxiongzhibo.IAP1",
                         @"com.kuxiongzhibo.IAP2",
                         @"com.kuxiongzhibo.IAP3"];
    
    NSSet *nsset = [NSSet setWithArray:product];
    _request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    _request.delegate = self;
    [_request start];
}
- (void)buyProduct:(SKProduct *)pro
{
    SKPayment *payment = [SKPayment paymentWithProduct:pro];
    WBLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma mark - SKProductsRequestDelegate 请求商品列表
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *product = response.products;
    if([product count] == 0) {
        //kALERT_TITLE(@"暂无可购买商品")
        return;
    }
    if ([self.delegate respondsToSelector:@selector(requestProductsDidReceiveProductsList:)]) {
        [self.delegate requestProductsDidReceiveProductsList:response.products];
    }
}

//    NSLog(@"productID:%@", response.invalidProductIdentifiers);
//    NSLog(@"产品付费数量:%ld",[product count]);
//        for (SKProduct *pro in product) {
//        NSLog(@"%@", [pro description]);
//        NSLog(@"%@", [pro localizedTitle]);
//        NSLog(@"%@", [pro localizedDescription]);
//        NSLog(@"%@", [pro price]);
//        NSLog(@"%@", [pro productIdentifier]);
        /*
         <SKProduct: 0x14f2c30b0>
         60个小熊蜜罐
         2016-06-27 23:35:04.896 ComradeUncle[20973:6491416] 6元购买60个小熊蜜罐
         2016-06-27 23:35:04.898 ComradeUncle[20973:6491416] 6
         2016-06-27 23:35:04.898 ComradeUncle[20973:6491416] com.xiaoxiongzhibo.goods.1
         */
//        if([pro.productIdentifier isEqualToString:self.productID.text]){
//            p = pro;
//        }
//    }
//}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{

    WBLog(@"内购商品列表 请求错误:%@", error);
    //kALERT_TITLE(@"商品请求失败");
    if ([self.delegate respondsToSelector:@selector(requestProductsDidReceiveProductsList:)]) {
        [self.delegate requestProductsDidReceiveProductsList:nil];
    }
}

- (void)requestDidFinish:(SKRequest *)request{
    //kHIDDEN_LOADING;
    WBLog(@"内购商品列表 反馈信息结束");
    if ([self.delegate respondsToSelector:@selector(requestProductsDidReceiveProductsList:)]) {
        [self.delegate requestProductsDidReceiveProductsList:nil];
    }
}

#pragma mark - 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{

    for(SKPaymentTransaction *tran in transaction){
        WBLog(@"SKPaymentTransaction %@",tran);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                // 发送到苹果服务器验证凭证
                [self verifyPurchaseWithPaymentTransaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];

                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSDictionary *userInfo = tran.error.userInfo;
                WBLog(@"%@",userInfo);
                NSString *string = userInfo[@"NSLocalizedDescription"];
                if (string) {
                    NSLog(@"失败啦！！！ %@",string);
                }else {
                    //kALERT_TITLE(@"交易失败，请重试");
                }
                break;
            }
            default:
                break;
        }
    }
}
//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)verifyPurchaseWithPaymentTransaction {
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:0];//转化为base64字符串
//    WBLog(@"%@",receiptString);
//    WBSelfInfoModel *selfModel = [PathAPI getSelfInfoModel];
//    //上传服务器$guid,$token,$apple_token
//    NSDictionary *dict = @{@"guid":selfModel.guid,
//                           @"token":selfModel.token,
//                           @"apple_token":receiptString};
//    //kSHOW_LOADING;
//    [[WBRequestManager shareManager] newPOSTRequestWithParameter:dict urlString:@"iospayment" andResultBlock:^(NSDictionary *receiveData) {
//        //kHIDDEN_LOADING;
//        if ([receiveData[@"ret"] integerValue] == 0) {
//            //kALERT_TITLE(@"购买成功");
//            //跟新蜜罐啊~
//            NSNumber *d_bal = receiveData[@"data"][@"d_bal"];
//            if ([self.delegate respondsToSelector:@selector(buyGoodsReceiveBearHoney:)]) {
//                [self.delegate buyGoodsReceiveBearHoney:d_bal];
//            }
//        }
//        WBLog(@"%@",receiveData[@"message"]);
//    }];
}
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
//    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //沙盒测试环境验证
//#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//    //正式环境验证
//#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
//
//    //创建请求到苹果官方进行购买验证
//    NSURL *url=[NSURL URLWithString:SANDBOX];
//    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
//    requestM.HTTPBody=bodyData;
//    requestM.HTTPMethod=@"POST";
//    //创建连接并发送同步请求
//    NSError *error=nil;
//    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
//    if (error) {
//        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
//        return;
//    }
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",dic);
//    if([dic[@"status"] intValue]==0){
//        NSLog(@"购买成功！");
//        NSDictionary *dicReceipt= dic[@"receipt"];
//        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
//        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
//        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        if ([productIdentifier isEqualToString:@"123"]) {
//            int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
//            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
//        }else{
//            [defaults setBool:YES forKey:productIdentifier];
//        }
//        //在此处对购买记录进行存储，可以存储到开发商的服务器端
//    }else{
//        NSLog(@"购买失败，未通过验证！");
//    }
//}

@end


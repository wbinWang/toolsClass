//
//  WBRequestManager.m
//  ComradeUncle
//
//  Created by wenbin on 16/6/16.
//  Copyright © 2016年 chenyue. All rights reserved.
//

#import "WBRequestManager.h"
@interface WBRequestManager()

/**
 *  上次请求的任务，判断当前任务和上一个一样，则取消上一个任务
 */
@property (nonatomic , strong)NSURLSessionDataTask *lastDataTask;

@end
@implementation WBRequestManager
+ (WBRequestManager *)shareManager
{
    static WBRequestManager *manager;
    if (!manager) {
        manager = [[WBRequestManager alloc]init];
    }
    return manager;
}
- (void)request:(NSMutableURLRequest *)urlRequest resultBlock:(ReceiveBlock)receiveBlock
{
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    urlRequest.timeoutInterval = 10;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *idDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.lastDataTask = nil;
        if (error) {
            WBLog(@"请求dataTaskWithRequest 错误%@",error.description);
            if (error.code == -999) {
                //该请求已经被取消
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *temp = @{@"ret":@10,
                                       @"message":@"网络不佳，请稍后再试"};
                if (receiveBlock) {
                    receiveBlock(temp);
                }
            });
            return;
        }
        if (!data.length) {
            //返回空，直接忽视吧~
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
            NSString *status = [NSString stringWithFormat:@"响应码 %ld",httpResp.statusCode];
            WBLog(@"new request result %@ -> 返回空~ %@",urlRequest.URL.description , status);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *temp = @{@"ret":@10,
                                       @"message":@"出错啦~"};
                if (receiveBlock) {
                    receiveBlock(temp);
                }
            });
            return ;
        }
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (result == nil) {
            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            WBLog(@"new request result %@ 请求下来的是string-> %@",urlRequest.URL.description,string);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *temp = @{@"ret":@10,
                                       @"message":@"请求失败，请重试"};
                if (receiveBlock) {
                    receiveBlock(temp);
                }
            });
            return;
        }
        WBLog(@"new request result %@--请求结果:%@",urlRequest.URL.absoluteString,result);
        if (receiveBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @try {
//                    if (result[@"ret"] && [result[@"ret"] integerValue] == 2 && result[@"message"] && [result[@"message"] hasSuffix:@"请重新登录"]) {
//                        WBLog(@"%@",result[@"message"]);
//                        //用户已经在其他设备登录啦~
//                        //您的账户可能在其它设备登录，为了您的账号安全，请重新登录
////                        [kNotiDefault postNotificationName:kNotifyOtherDeviceLogin object:nil];
//                    }else {
                        //正常情况！！！！！！！！
                        receiveBlock(result);
//                    }
                } @catch (NSException *exception) {
                    NSLog(@"%@ 崩溃了",urlRequest.URL.absoluteString);
                    NSDictionary *temp = @{@"ret":@10,
                                           @"message":@"请求失败，请重试"};
                    receiveBlock(temp);
                } @finally {
                    
                }
            });
        }
    }];
    WBLog(@"DataTask new %@",idDataTask.originalRequest);
    if (self.lastDataTask){
        
        NSString *lastRequestUrl = [self.lastDataTask.originalRequest.URL description];
        
        if ([lastRequestUrl isEqualToString:[urlRequest.URL description]]) {
            
            NSData *lastHttpBody = self.lastDataTask.originalRequest.HTTPBody;
            NSData *currHttpBody = urlRequest.HTTPBody;
            if ((lastHttpBody && currHttpBody && [lastHttpBody isEqual:currHttpBody]) ||
                (!lastHttpBody && !currHttpBody)) {
                WBLog(@"主动取消 请求进程 %@",self.lastDataTask.originalRequest);
                [self.lastDataTask cancel];
            }
        }
    }
    self.lastDataTask = idDataTask;
    [idDataTask resume];
}
#pragma mark - 新的网络地址去请求
/**带参数的网络请求 POST*/
- (void)newPOSTRequestWithParameter:(NSDictionary *)parameter urlString:(NSString *)subAddress andResultBlock:(ReceiveBlock)receiveBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kSERVER_ADDRESS,subAddress];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"POST";
    WBLog(@"new request post : %@",urlStr);
    
    if (parameter) {
        NSError *JsonError;
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:&JsonError];
        request.HTTPBody = data;
    }
    
    [self request:request resultBlock:receiveBlock];
}
/**网络请求 GET*/
- (void)newGETRequestWithParameter:(NSDictionary *)parameter urlString:(NSString *)subAddress andResultBlock:(ReceiveBlock)receiveBlock
{
    NSString *str = [NSString stringWithFormat:@"%@/%@",kSERVER_ADDRESS,subAddress];
    if (parameter) {
        //拼接参数
        NSArray *allValues = parameter.allValues;
        for (NSString *value in allValues) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"/%@",value]];
        }
    }
    WBLog(@"new request get : %@",str);
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    [self request:request resultBlock:receiveBlock];
}
/**
 *  同步请求方法
 *
 *  @param method     <#method description#>
 *  @param parameter  <#parameter description#>
 *  @param subAddress <#subAddress description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)synchronizationRequstWithMethod:(NSString *)method Parameter:(NSDictionary *)parameter urlString:(NSString *)subAddress
{
    //设置同步请求
    NSString *urlStr = subAddress;//[NSString stringWithFormat:@"%@/%@",kSERVER_ADDRESS,subAddress];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 5.0;
    request.HTTPMethod = method;
    
    NSError *JsonError;
    if (parameter) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:&JsonError];
        request.HTTPBody = data;
    }
    
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *receiveData;
    if (resultData) {
        receiveData = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
        if (receiveData == nil) {
            WBLog(@"%@ -> %@",urlStr,[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                //kALERT_TITLE(@"请求失败，请重试");
            });
        }
    }
    WBLog(@"%@%@",urlStr , receiveData);
    return receiveData;
}

//- (void)cancelRequestTaskWithParameter:(NSDictionary *)parameter urlString:(NSString *)subAddress withMethod:(NSString *)method
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kSERVER_ADDRESS,subAddress];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    request.HTTPMethod = method;
//    
//    if (parameter) {
//        NSError *JsonError;
//        NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:&JsonError];
//        request.HTTPBody = data;
//    }
//    
//}

@end

//
//  WBStoreBuyManager.h
//  ComradeUncle
//
//  Created by wenbin on 16/6/27.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@protocol WBStoreBuyDelegate <NSObject>

- (void)requestProductsDidReceiveProductsList:(NSArray *)list;

- (void)buyGoodsReceiveBearHoney:(NSNumber *)bearHoney;

@end

@interface WBStoreBuyManager : NSObject <SKPaymentTransactionObserver , SKProductsRequestDelegate>
/**
 *  请求商品列表
 */
- (void)beginRequstProductsInfo;

/**
 *  购买商品
 *
 *  @param pro 商品
 */
- (void)buyProduct:(SKProduct *)pro;

@property (nonatomic , weak)id<WBStoreBuyDelegate>delegate;

@end

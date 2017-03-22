//
//  UIWebView+CustomLoad.h
//  DarkHorse750
//
//  Created by wenbin on 2017/3/10.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (CustomLoad)

/**
 *  直接从字符串加载网页~
 */
- (void)loadWebFromString:(NSString *)string;

@end

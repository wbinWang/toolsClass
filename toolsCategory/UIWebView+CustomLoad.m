//
//  UIWebView+CustomLoad.m
//  DarkHorse750
//
//  Created by wenbin on 2017/3/10.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

#import "UIWebView+CustomLoad.h"

@implementation UIWebView (CustomLoad)

- (void)loadWebFromString:(NSString *)string
{
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
}

@end

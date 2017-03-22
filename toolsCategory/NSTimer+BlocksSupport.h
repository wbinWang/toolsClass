//
//  NSTimer+BlocksSupport.h
//  ComradeUncle
//
//  Created by wenbin on 16/7/1.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlocksSupport)

/**
 *  消除循环引用
 *
 *  @param interval <#interval description#>
 *  @param block    <#block description#>
 *  @param repeats  <#repeats description#>
 *
 *  @return <#return value description#>
 */
+ (NSTimer *)WBScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
/**
 *  使定时器无能
 */
- (void)disable;

@end

//
//  NSTimer+BlocksSupport.m
//  ComradeUncle
//
//  Created by wenbin on 16/7/1.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "NSTimer+BlocksSupport.h"

@implementation NSTimer (BlocksSupport)

+ (NSTimer *)WBScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        block:(void(^)())block
                                      repeats:(BOOL)repeats
{
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
    
    return timer;
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}

- (void)disable
{
    [self invalidate];
}

@end

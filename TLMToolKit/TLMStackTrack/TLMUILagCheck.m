//
//  TLMUILagCheck.m
//  Pods
//
//  Created by tongleiming on 2019/7/1.
//

#import "TLMUILagCheck.h"
#import "TLMStackTrack.h"

@interface TLMUILagCheck () {
    int timeoutCount;
    CFRunLoopObserverRef runLoopObserver;
    @public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}

@end

@implementation TLMUILagCheck

+ (instancetype)sharedManager {
    static TLMUILagCheck *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TLMUILagCheck alloc] init];
    });
    return instance;
}

- (void)beginMonitor {
    
    if (runLoopObserver) {
        return;
    }
    
    dispatchSemaphore = dispatch_semaphore_create(0);
    
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            0,
                                                            &runLoopObserverCallBack,
                                                            &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    // 监控子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            // 最多等3秒
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC));
            if (semaphoreWait != 0) {   // 返回值非0，则说明发生超时
                if (!self->runLoopObserver) { // observer不存在，直接返回退出while循环
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                
                // runLoopActivity == kCFRunLoopBeforeSources:因为执行source而久久不能进入睡眠；
                // runLoopActivity == kCFRunLoopAfterWaiting:因为唤醒的事件久久不能处理完
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    if (++self->timeoutCount < 3) {   // 连续发生两次超时，认为是UI卡顿
                        continue;
                    }
                    NSLog(@"触发UI卡顿监控");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        // 上报栈帧
                        NSString *trackResult = [[TLMStackTrack sharedManager] trackStack];
                        NSString *fileName= [[TLMStackTrack sharedManager] trackFileNameWithType:TLMTrackUILag];
                        [[TLMStackTrack sharedManager] uploadStackTrack:trackResult traceName:fileName];
                    });
                }
            }
            self->timeoutCount = 0;
        }
    });
}

- (void)endMonitor {
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    TLMUILagCheck *lagMonitor = (__bridge TLMUILagCheck *)info;
    lagMonitor->runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@end

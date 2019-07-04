//
//  TLMBackgroundTaskCheck.m
//  Pods
//
//  Created by tongleiming on 2019/7/1.
//

#import "TLMBackgroundTaskCheck.h"
#import "TLMStackTrack.h"

@interface TLMBackgroundTaskCheck ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;

@end

@implementation TLMBackgroundTaskCheck

+ (instancetype)sharedManager {
    static TLMBackgroundTaskCheck *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TLMBackgroundTaskCheck alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskIdentifier = UIBackgroundTaskInvalid;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadStackFramesFiles:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBackgrounTask:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)uploadStackFramesFiles:(NSNotification *)notification {
    [[TLMStackTrack sharedManager] uploadLocalStackFramesFiles];
}

- (void)checkBackgrounTask:(NSNotification *)notification {
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (self) {
            NSString *trackResult = [[TLMStackTrack sharedManager] trackStack];
            NSString *fileName= [[TLMStackTrack sharedManager] trackFileNameWithType:TLMTrackBackgroundTask];
            [[TLMStackTrack sharedManager] storeToDiskForStackFrames:trackResult fileName:fileName];
            [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
            self.taskIdentifier = UIBackgroundTaskInvalid;
        }
    }];
    
//    NSTimeInterval timeRemaining = [UIApplication sharedApplication].backgroundTimeRemaining;
//    dispatch_queue_t queue = dispatch_queue_create("backgroundTask.check.queue", 0);
//
//
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeRemaining - 3) * NSEC_PER_SEC)), queue, ^{
//        NSString *trackResult = [[TLMStackTrack sharedManager] trackStack];
//        NSString *fileName= [[TLMStackTrack sharedManager] trackFileNameWithType:TLMTrackBackgroundTask];
//        [[TLMStackTrack sharedManager] storeToDiskForStackFrames:trackResult fileName:fileName];
//        [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
//        self.taskIdentifier = UIBackgroundTaskInvalid;
//    });
}

@end

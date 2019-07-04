//
//  XCMonitorLog.m
//  Pods
//
//  Created by tongleiming on 2019/7/4.
//

#import "XCMonitorLog.h"

@interface XCMonitorLog ()

@property (nonatomic, strong) NSString *diskPath;

@end

@implementation XCMonitorLog

- (NSString *)makeDiskPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *stackTrackDirectory = [paths[0] stringByAppendingPathComponent:@"TLMStackTrack"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:stackTrackDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:stackTrackDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return stackTrackDirectory;
}

- (NSString *)makeStorePathWithFileName:(NSString *)fileName {
    if (fileName.length == 0) {
        return nil;
    }
    NSString *logPath = [NSString stringWithFormat:@"%@/%@", self.diskPath, fileName];
    return logPath;
}

- (void)storeToDiskForStackFrames:(NSString *)stackFrames fileName:(NSString *)fileName {
    NSString *storePath = [self makeStorePathWithFileName:fileName];
    [stackFrames writeToFile:storePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end

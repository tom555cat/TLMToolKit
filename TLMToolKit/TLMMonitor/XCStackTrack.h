//
//  XCStackTrack.h
//  Pods
//
//  Created by tongleiming on 2019/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XCTrackType) {
    XCTrackBackgroundTask = 0,
    XCTrackUILag,
    XCTackOOM
};

@interface XCStackTrack : NSObject

+ (instancetype)sharedManager;

- (NSString *)trackStack;

- (NSString*)trackFileNameWithType:(XCTrackType)type;

- (void)storeToDiskForStackFrames:(NSString *)stackFrames fileName:(NSString *)fileName;

- (void)uploadLocalStackFramesFiles;

- (void)uploadStackTrack:(NSString *)traceContent traceName:(NSString *)traceName;

@end

NS_ASSUME_NONNULL_END

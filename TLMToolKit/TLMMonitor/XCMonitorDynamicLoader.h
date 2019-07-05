//
//  XCMonitorDynamicLoader.h
//  Pods
//
//  Created by tongleiming on 2019/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct RAM_Function {
    char *key;
    void (*function)(void);
};

#define RAM_FUNCTION_EXPORT(key) \
static void _ram##key(void); \
__attribute__((used, section("__DATA," "__"#key ".func"))) \
static const struct RAM_Function __F##key = (struct RAM_Function){(char *)(&#key), (void *)(&_ram##key)}; \
static void _ram##key \

@interface XCMonitorDynamicLoader : NSObject

+ (void)executeFunctionsForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

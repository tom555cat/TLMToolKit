//
//  XCDynamicLoader.h
//  Pods
//
//  Created by tongleiming on 2019/6/24.
//

#import <Foundation/Foundation.h>


typedef void (*XCDynamicLoaderInjectFunction)(void);

#define XCDYML_SEGMENTNAME      "__DATA"
#define XCDYML_SECTION_SUFFIX   "xc_func"

#pragma mark - 实现存储函数
struct XC_Function {
    char *key;
    void (*function)(void);
};

#define XC_FUNCTION_EXPORT(key) \
static void _xc##key(void); \
__attribute__((used, section(XCDYML_SEGMENTNAME ",__"#key XCDYML_SECTION_SUFFIX))) \
static const struct XC_Function __F##key = (struct XC_Function){(char *)(&#key), (void *)(&_xc##key)}; \
static void _xc##key \


@interface XCDynamicLoader : NSObject

+ (void)executeFunctionsForKey:(NSString *)key;

@end


//
//  XCDynamicLoader.h
//  Pods
//
//  Created by tongleiming on 2019/6/24.
//

#import <Foundation/Foundation.h>


typedef void (*XCDynamicLoaderInjectFunction)(void);

#define XCDYML_SEGMENTNAME "__DATA"
#define XCDYML_ATTRIBUTE(sectionName) __attribute((used, section(XCDYML_SEGMENTNAME "," #sectionName )))

#define XCDYML_FUNCTIONS_EXPORT_BEGIN(KEY) \
static void XCDYML_INJECT_##KEY##_FUNCTION(void){

#define XCDYML_FUNCTIONS_EXPORT_END(KEY) \
} \
static XCDynamicLoaderInjectFunction dymlLoader##KEY##function XCDYML_ATTRIBUTE(KEY) = XCDYML_INJECT_##KEY##_FUNCTION;

//---------------------------------------------------------------

//#pragma mark - 实现存储函数
//struct XC_Function {
//    char *key;
//    void (*function)(void);
//};
//
//#define XC_FUNCTION_EXPORT(key) \
//static void _xc##key(void); \
//__attribute__((used, section(XCDYML_SEGMENTNAME ",__"#key ".func"))) \
//static const struct XC_Function __F##key = (struct XC_Function){(char *)(&#key), (void *)(&_xc##key)}; \
//static void _xc##key \
//
//#pragma mark - 实现存储block
//struct XC_Block {
//    char *key;
//    __unsafe_unretained void (^block)(void);
//};
//
//#define XC_BLOCKS_EXPORT(key, block) __attribute__((used, section(XCDYML_SEGMENTNAME ",__"#key ".block"))) \
//static const struct XC_Block __B##key = (struct XC_Block){((char *)&#key), block};
//
//#pragma mark - 实现存储字符串
//struct XC_String {
//    __unsafe_unretained NSObject *key;
//    __unsafe_unretained NSObject *value;
//};
///// id 参数，在同一个.m文件中调用此宏需要id唯一
//#define XC_STRINGS_EXPORT(key, value, id) __attribute__((used, section(XCDYML_SEGMENTNAME ",__xc.data"))) \
//static const struct XC_String __S##id= (struct XC_String){key, value};
//
//#pragma mark - 收集实现了该宏的类
//#define XC_FUNCTIONNAME_EXPORT __attribute__((used, section(XCDYML_SEGMENTNAME ", __funcName"))) \
//static const char *__xc_funcName__ = __func__

@interface XCDynamicLoader : NSObject

+ (void)executeFunctionsForLevel:(NSString *)level;

//+ (void)executeFunctionsForKey:(NSString *)key;

@end


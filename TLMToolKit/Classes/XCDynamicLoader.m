//
//  XCDynamicLoader.m
//  Pods
//
//  Created by tongleiming on 2019/6/24.
//

#import "XCDynamicLoader.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import "XCModuleManager.h"

#ifdef __LP64__
typedef uint64_t XCExportValue;
typedef struct section_64 XCExportSection;
#define XCGetSectByNameFromHeader getsectbynamefromheader_64
#else
typedef uint32_t XCExportValue;
typedef struct section XCExportSection;
#define XCGetSectByNameFromHeader getsectbynamefromheader
#endif

//NSArray<NSValue *>* XCReadModuleInitFunction(char *sectionName, const struct mach_header *mhp);

//static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
//    for (NSString *level in [XCModuleManager sharedManager].levelArray) {
//        char *sectionName = (char *)[level cStringUsingEncoding:NSUTF8StringEncoding];
//        if (sectionName) {
//            NSArray *funcArray = XCReadModuleInitFunction(sectionName, mhp);
//            [[XCModuleManager sharedManager] addModuleInitFuncs:funcArray forLevel:level];
//        }
//    }
//}

//NSArray<NSValue *>* XCReadModuleInitFunction(char *sectionName, const struct mach_header *mhp) {
//    NSMutableArray *funcArray = [NSMutableArray array];
//    unsigned long size = 0;
//#ifndef __LP64__
//    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
//#else
//    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
//    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
//#endif
//
//    unsigned long counter = size/sizeof(void*);
//    for (int idx = 0; idx < counter; ++idx) {
//        XCDynamicLoaderInjectFunction func = (XCDynamicLoaderInjectFunction)memory[idx];
//        [funcArray addObject:[NSValue valueWithPointer:func]];
//    }
//    return funcArray;
//}

static void XCDynamicLoader_invoke_method(NSString *level){
    NSArray *funcArray = [[[XCModuleManager sharedManager] modInitFuncPtrArrayLevelDic] objectForKey:level];
    for (NSValue *val in funcArray) {
        XCDynamicLoaderInjectFunction func = val.pointerValue;
        func();
    }
}


NSArray<NSValue *>* XCReadSection(char *sectionName, const struct mach_header *mhp);

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    for (NSString *level in [XCModuleManager sharedManager].levelArray) {
        NSString *fKey = [NSString stringWithFormat:@"__%@%s", level?:@"", XCDYML_SECTION_SUFFIX];
        NSArray *funcArray = XCReadSection((char *)[fKey UTF8String], mhp);
        [[XCModuleManager sharedManager] addModuleInitFuncs:funcArray forLevel:level];
    }
}

NSArray<NSValue *>* XCReadSection(char *sectionName, const struct mach_header *mhp) {
    NSMutableArray *funcArray = [NSMutableArray array];
    
    const XCExportValue mach_header = (XCExportValue)mhp;
    const XCExportSection *section = XCGetSectByNameFromHeader((void *)mach_header, XCDYML_SEGMENTNAME, sectionName);
    if (section == NULL) return @[];
    
    int addrOffset = sizeof(struct XC_Function);
    for (XCExportValue addr = section->offset;
         addr < section->offset + section->size;
         addr += addrOffset) {
        
        struct XC_Function entry = *(struct XC_Function *)(mach_header + addr);
        [funcArray addObject:[NSValue valueWithPointer:entry.function]];
    }
    
    return funcArray;
}

__attribute__((constructor))
void initXCProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

@implementation XCDynamicLoader

//+ (void)executeFunctionsForLevel:(NSString *)level {
//    XCDynamicLoader_invoke_method(level);
//}

+ (void)executeFunctionsForKey:(NSString *)key {
    XCDynamicLoader_invoke_method(key);
}

@end

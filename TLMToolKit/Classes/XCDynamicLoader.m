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


static void XCDynamicLoader_invoke_method(NSString *level){
    NSArray *funcArray = [[[XCModuleManager sharedManager] modInitFuncPtrArrayLevelDic] objectForKey:level];
    for (NSValue *val in funcArray) {
        XCDynamicLoaderInjectFunction func = val.pointerValue;
        func();
    }
    
//    Dl_info info;
//    int ret = dladdr(XCDynamicLoader_invoke_method, &info);
//    if(ret == 0){
//        // fatal error
//    }
//#ifndef __LP64__
//    const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
//    unsigned long size = 0;
//    uint32_t *memory = (uint32_t*)getsectiondata(mhp, QWLoadableSegmentName, QWLoadableSectionName, & size);
//#else /* defined(__LP64__) */
//    const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
//    unsigned long size = 0;
//    uint64_t *memory = (uint64_t*)getsectiondata(mhp, XCDYML_SEGMENTNAME, key, &size);
//#endif /* defined(__LP64__) */
//
//    for(int idx = 0; idx < size/sizeof(void*); ++idx){
//        XCDynamicLoaderInjectFunction func = (XCDynamicLoaderInjectFunction)memory[idx];
//        func(); //crash tofix
//    }
}

NSArray<NSValue *>* XCReadModuleInitFunction(char *sectionName, const struct mach_header *mhp);
static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    for (NSString *level in [XCModuleManager sharedManager].levelArray) {
        char *sectionName = (char *)[level cStringUsingEncoding:NSUTF8StringEncoding];
        if (sectionName) {
            NSArray *funcArray = XCReadModuleInitFunction(sectionName, mhp);
            [[XCModuleManager sharedManager] addModuleInitFuncs:funcArray forLevel:level];
        }
    }
}

NSArray<NSValue *>* XCReadModuleInitFunction(char *sectionName, const struct mach_header *mhp) {
    NSMutableArray *funcArray = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for (int idx = 0; idx < counter; ++idx) {
        XCDynamicLoaderInjectFunction func = (XCDynamicLoaderInjectFunction)memory[idx];
        [funcArray addObject:[NSValue valueWithPointer:func]];
//        [[XCModuleManager sharedManager] addModuleInitFunc:func forLevel:[NSString stringWithUTF8String:sectionName]];
    }
    return funcArray;
}

__attribute__((constructor))
void initXCProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

@implementation XCDynamicLoader

+ (void)executeFunctionsForLevel:(NSString *)level {
    XCDynamicLoader_invoke_method(level);
}

@end

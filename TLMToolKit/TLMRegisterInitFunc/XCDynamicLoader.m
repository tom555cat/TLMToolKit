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

static void XCDynamicLoader_invoke_method(NSString *level){
    NSArray *funcArray = [[[XCModuleManager sharedManager] modInitFuncPtrArrayStageDic] objectForKey:level];
    for (NSValue *val in funcArray) {
        XCDynamicLoaderInjectFunction func = val.pointerValue;
        func();
    }
}

NSArray<NSValue *>* XCReadSection(char *sectionName, const struct mach_header *mhp);

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    for (NSString *stage in [XCModuleManager sharedManager].stageArray) {
        NSString *fKey = [NSString stringWithFormat:@"__%@%s", stage?:@"", XCDYML_SECTION_SUFFIX];
        NSArray *funcArray = XCReadSection((char *)[fKey UTF8String], mhp);
        [[XCModuleManager sharedManager] addModuleInitFuncs:funcArray forStage:stage];
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

+ (void)executeFunctionsForKey:(NSString *)key {
    XCDynamicLoader_invoke_method(key);
}

@end

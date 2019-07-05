//
//  XCMonitorDynamicLoader.m
//  Pods
//
//  Created by tongleiming on 2019/7/5.
//

#import "XCMonitorDynamicLoader.h"

#import <dlfcn.h>
#import <objc/runtime.h>

#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <mach-o/ldsyms.h>

#ifdef __LP64__
typedef uint64_t RAMExportValue;
typedef struct section_64 RAMExportSection;
#define RAMGetSectByNameFromHeader getsectbynamefromheader_64
#else
typedef uint32_t RAMExportValue;
typedef struct section RAMExportSection;
#define RAMGetSectByNameFromHeader getsectbynamefromheader
#endif

void RAMExecuteFunction(char *key) {
    Dl_info info;
    dladdr((const void *)&RAMExecuteFunction, &info);
    
    const RAMExportValue mach_header = (RAMExportValue)info.dli_fbase;
    const RAMExportSection *section = RAMGetSectByNameFromHeader((void *)mach_header, "__DATA", key);
    if (section == NULL) return;
    
    int addrOffset = sizeof(struct RAM_Function);
    for (RAMExportValue addr = section->offset;
         addr < section->offset + section->size;
         addr += addrOffset) {
        
        struct RAM_Function entry = *(struct RAM_Function *)(mach_header + addr);
        entry.function();
    }
}

@implementation XCMonitorDynamicLoader

+ (void)executeFunctionsForKey:(NSString *)key {
    NSString *fKey = [NSString stringWithFormat:@"__%@.func", key?:@""];
    RAMExecuteFunction((char *)[fKey UTF8String]);
}

@end

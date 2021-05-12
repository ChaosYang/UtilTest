//
//  UIDevice+Additional.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/5/12.
//

#import "UIDevice+Additional.h"
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

@implementation UIDevice (Additional)

- (BOOL)isIphoneX{
    static BOOL iphoneX;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) { // 仅对于系统版本11及以上
            UIEdgeInsets safeEdgeInsets;
            if ((NSClassFromString(@"SceneDelegate")) != nil) { // 场景存在的情况下 delegate默认不存在window
                safeEdgeInsets = [[[UIApplication sharedApplication] windows].firstObject safeAreaInsets];
            }else {
                safeEdgeInsets = [[[[UIApplication sharedApplication] delegate] window] safeAreaInsets];
            }
            if (safeEdgeInsets.bottom > 0.0) {
                iphoneX = YES;
            }else{
                iphoneX = NO;
            }
            return;
        }
        // 通用
        BOOL isIphone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = MAX(screenHeight, screenWidth);
        iphoneX = (isIphone && (height >= 812.0));
    });
    return iphoneX;
}


- (BOOL)isJailBreak{
    static BOOL jailBreak;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self isJailBreakFirst]
            || [self isJailBreakSecond]
            || [self isJailBreakThird]
            || [self isJailBreakFourth]
            || checkCydia()) {
            jailBreak = YES;
        }
        jailBreak = NO;
    });
    return jailBreak;
}



- (BOOL)isJailBreakFirst{
    NSArray *jailbreak_tool_paths = @[@"/Applications/Cydia.app",
                                      @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                      @"/bin/bash",
                                      @"/usr/sbin/sshd",
                                      @"/etc/apt"
                                      ];
    for (int i=0; i<jailbreak_tool_paths.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_paths[i]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isJailBreakSecond{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isJailBreakThird{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
//        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
    
        return YES;
    }
    return NO;
}

int checkInject(void) {
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char*, struct stat*) = stat;
    char *dylib_name = "/usr/lib/system/libsystem_kernel.dylib";
    if ((ret = dladdr(func_stat, &dylib_info)) && !strncmp(dylib_info.dli_fname, dylib_name, strlen(dylib_name))) {
        return 0;
    }
    return 1;
}

int checkCydia(void) {
    struct stat stat_info;
    if (!checkInject()) {
        if (0 == stat("/Applications/Cydia.app", &stat_info)) {
            return 1;
        }
    } else {
        return 1;
    }
    return 0;
}

char* printEnv(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    return env;
}

- (BOOL)isJailBreakFourth{
    if (printEnv()) {
        return YES;
    }
    return NO;
}


- (BOOL)isSimulator{
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}


- (BOOL)isIpad{
    static BOOL ipad;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ipad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    });
    return ipad;
}

@end

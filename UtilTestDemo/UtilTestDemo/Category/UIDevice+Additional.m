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
#import <sys/utsname.h>

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

// MARK: 每mm对应的pt数量
- (double)ptPer_mm{
    static double pt = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        double sc_w = [[UIScreen mainScreen] bounds].size.width;
        double sc_h = [[UIScreen mainScreen] bounds].size.height;
        double sc_s;
        double ff = [[UIScreen mainScreen] nativeBounds].size.height;
        
        if (ff == 480) {
            sc_s = 3.5;
        } else if (ff == 960) {
            sc_s = 3.5;
        } else if (ff == 1136) {
            sc_s = 4.0;
        } else if(ff == 1334.0) {   // iPhone 8、iPhone 7、iPhone 6s、iPhone 6、iPhone SE 2nd gen
            // 实测 iPhone 8 、 iPhone 6s 、 iPhone 7
            // 模拟器测 iPhone SE 2nd gen
            sc_s = 4.7 ;
        } else if (ff == 2208) {    // iPhone 7 Plus、iPhone 6s Plus、iPhone 6 Plus
    //        sc_s = 5.5;
            // 模拟器微调    iPhone 7 Plus、iPhone 6s Plus
            sc_s = 5.4912;
        } else if (ff == 2436) {    // iPhone 11 Pro、iPhone XS、iPhone X
    //        sc_s = 5.85;
            // 实测 iPhone X
            // 模拟器与真机不一致，以真机为准
            sc_s = 5.8;
        } else if (ff == 2688) {    // iPhone XS Max、iPhone 11 Pro Max
            // 实测 iPhone XS Max
            // 模拟器与真机不一致，以真机为准
    //        sc_s = 6.46;
            sc_s = 6.425;
        } else if (ff == 1792) {    // iPhone 11、iPhone XR
            // 实测 iPhone 11
            // 模拟器 iPhone XR
            sc_s = 6.05;
            
        } else if (ff == 2532) {    // iPhone 12 Pro、iPhone 13、iPhone 13 Pro、iPhone 12
            // 实测 iPhone 12 Pro
            // 模拟器  iPhone 13、iPhone 13 Pro、iPhone 12
            sc_s = 6.06;
        } else if (ff == 2340) {    // iPhone 13 mini、iPhone 12 mini
    //        sc_s = 5.42;
            // 使用模拟器微调  iPhone 13 mini、iPhone 12 mini
            sc_s = 5.41;
        } else if (ff == 2778) {    // iPhone 12 Pro Max、iPhone 13 Pro Max
            // 实测 iPhone 12 Pro Max
            // 模拟器测 iPhone 13 Pro Max
            sc_s = 6.68;
        } else if (ff == 1920) {    // iPhone 8 Plus
    //        sc_s = 5.5;
            // 使用模拟器微调
            sc_s = 5.526;
        } else if (ff == 2556) {    // iPhone 14 Pro
            // 使用官方给的参数，无实测
            sc_s = 6.12;
        } else if (ff == 2796) {    // iPhone 14 Pro Max
            // 使用官方给的参数，无实测
            sc_s = 6.69;
        } else if (ff == 2868) { // iphone 16 pro max
            sc_s = 6.88;
        } else if (ff == 2622) {
            sc_s = 6.3;
        }
        // ---------- iPad 端 ---------------------------------------
        else if (ff == 2266) {  // iPad Mini (6th gen)
            sc_s = 8.3;
        } else if (ff == 2160) {    //  iPad 9th gen、iPad 8th gen、iPad 7th gen
            sc_s = 10.2;
        } else if (ff == 2732) {    // iPad Pro (5th gen 12.9")、iPad Pro (4th gen 12.9")、iPad Pro (3rd gen 12.9")、iPad Pro (2nd gen 12.9")、iPad Pro (1st gen 12.9")
            sc_s = 12.9;
        } else if (ff == 2388) {    // iPad Pro (5th gen 11")、iPad Pro (4th gen 11")、iPad Pro (3rd gen 11")
            sc_s = 11.0;
        } else if (ff == 2360) {
            sc_s = 10.9;
        } else if (ff == 2048) {
            if ([self isIpadMini]) {  // iPad Mini (5th gen)、iPad mini 4、iPad mini 3、iPad mini 2、
                sc_s = 7.9;
            } else {    // iPad 6th gen、iPad 5th gen、iPad Pro (1st gen 9.7”)、iPad Air 2、iPad Air、iPad 4th gen、iPad 3rd gen
                sc_s = 9.7;
            }
        } else if (ff == 2224) {    // iPad Air (3rd gen)、iPad Pro (2nd gen 10.5")
            sc_s = 10.5;
        } else if (ff == 1024) {
            if ([self isIpadMini]) {  // iPad mini
                sc_s = 7.9;
            } else {    // iPad 2、iPad 1st gen
                sc_s = 9.7;
            }
        }
        else{
            sc_s = 6.7;
        }
        
        // 1mm米的像素点
        double pmm = sqrt(sc_w * sc_w + sc_h * sc_h)/(sc_s * 25.39999918);//mm
        pt = pmm;
    });
    return pt;
}

- (BOOL)isIpadMini {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPad2,5"] ||
        [deviceString isEqualToString:@"iPad2,6"] ||
        [deviceString isEqualToString:@"iPad2,7"] ||
        [deviceString isEqualToString:@"iPad4,4"] ||
        [deviceString isEqualToString:@"iPad4,5"] ||
        [deviceString isEqualToString:@"iPad4,6"] ||
        [deviceString isEqualToString:@"iPad4,7"] ||
        [deviceString isEqualToString:@"iPad4,8"] ||
        [deviceString isEqualToString:@"iPad4,9"] ||
        [deviceString isEqualToString:@"iPad5,1"] ||
        [deviceString isEqualToString:@"iPad5,2"]) {
        return YES;
    }
    return NO;
}

- (double)statusBarHeight {
    static double height = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) { // 仅对于系统版本11及以上
            UIEdgeInsets safeEdgeInsets;
            if ((NSClassFromString(@"SceneDelegate")) != nil) { // 场景存在的情况下 delegate默认不存在window
                safeEdgeInsets = [[[UIApplication sharedApplication] windows].firstObject safeAreaInsets];
            }else {
                safeEdgeInsets = [[[[UIApplication sharedApplication] delegate] window] safeAreaInsets];
            }
            height = safeEdgeInsets.top;
        } else {
            height = self.isIphoneX ? 44: 20;
        }
    });
    return height;
}

@end

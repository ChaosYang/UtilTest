//
//  NSObject+VTKVO.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/5/6.
//

#import "NSObject+VTKVO.h"
#import <objc/runtime.h>

@implementation NSObject (VTKVO)

+ (void)load
{
    [self switchMethod];
}


- (void)removeViewer:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    @try {
        [self removeViewer:observer forKeyPath:keyPath];
    } @catch (NSException *exception) {
        NSLog(@"KVO keyPath<%@> not register",keyPath);
    }
}


+ (void)switchMethod
{
    SEL removeSel = @selector(removeObserver:forKeyPath:);
    SEL myRemoveSel = @selector(removeViewer:forKeyPath:);
    
    Method systemRemoveMethod = class_getClassMethod([self class],removeSel);
    Method DasenRemoveMethod = class_getClassMethod([self class], myRemoveSel);
    
    method_exchangeImplementations(systemRemoveMethod, DasenRemoveMethod);
}


@end

//
//  NSObject+HCHook.m
//  HCRefresh
//
//  Created by chenhao on 16/10/19.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "NSObject+HCHook.h"
#import <objc/message.h>
#import <objc/runtime.h>


@implementation NSObject (HCHook)

-(void)hc_hookSelector:(SEL)selector withAfterBlock:(void(^)())block
{
    Method origMethod = class_getInstanceMethod([self class],
                                                selector);
    IMP origIMP = method_getImplementation(origMethod);
    
    IMP newIMP = imp_implementationWithBlock(^void(){
        
        //先调用原来的方法实现
        origIMP(self, selector);
        //调用新增代码
        block();
    });
    
    method_setImplementation(origMethod, newIMP);
}



@end

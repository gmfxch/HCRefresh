//
//  NSObject+HCHook.h
//  HCRefresh
//
//  Created by chenhao on 16/10/19.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HCHook)

-(void)hc_hookSelector:(SEL)selector withAfterBlock:(void(^)())block;

@end

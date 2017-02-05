//
//  UIBezierPath+StringPath.h
//  AnimationDemo
//
//  Created by chenhao on 16/9/23.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git

#import <UIKit/UIKit.h>

@interface UIBezierPath (StringPath)

+(UIBezierPath*)pathWithNSString:(NSString*)string  font:(UIFont*)font;

@end

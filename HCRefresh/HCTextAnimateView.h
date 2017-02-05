//
//  CHTextAnimateView.h
//  AnimationDemo
//
//  Created by chenhao on 16/9/23.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git

#import <UIKit/UIKit.h>

@interface HCTextAnimateView : UIView

@property(nonatomic, assign)CGFloat  progress;
@property(nonatomic, strong)UIColor  *textColor;
@property(nonatomic, strong)UIColor  *fillColor;
@property(nonatomic, strong)UIColor  *animateTinColor;

-(instancetype)initWithTitle:(NSString*)title   font:(UIFont*)font;

-(void)startAnimate;
-(void)stopAnimate;


@end

//
//  CHTextAnimateView.m
//  AnimationDemo
//
//  Created by chenhao on 16/9/23.
//  Copyright © 2016年 chenhao. All rights reserved.
////  代码地址：https://github.com/gmfxch/HCRefresh.git

#define TINCOLOR_PERSENT  0.3
#define ANIMATE_TIME      1.6

#import "HCTextAnimateView.h"
#import "UIBezierPath+StringPath.h"
#import "HCRefresh.h"

@implementation HCTextAnimateView
{
    CAShapeLayer *_shapLayer;
    CADisplayLink *_link;
    CAGradientLayer *_gradientLayer;
    CGSize          textSize;
}

-(instancetype)initWithTitle:(NSString*)title   font:(UIFont*)font
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
        shapLayer.fillRule = kCAFillRuleEvenOdd;
        shapLayer.lineCap = kCALineCapButt;
        shapLayer.lineWidth = 1.0;
        shapLayer.fillMode = kCAFillModeForwards;
        shapLayer.lineJoin = kCALineJoinMiter;
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        shapLayer.geometryFlipped = YES;
        [self.layer addSublayer:shapLayer];
        _shapLayer = shapLayer;
        
        UIBezierPath *path = [UIBezierPath pathWithNSString:title font:font];
        shapLayer.path = path.CGPath;
        
        CGRect frame = [title boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
        textSize = frame.size;
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _shapLayer.frame = CGRectMake(self.bounds.size.width/2.0 - textSize.width/2.0, self.bounds.size.height/2.0 - textSize.height/2.0, textSize.width, textSize.height);
}


-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _shapLayer.strokeEnd = progress;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _shapLayer.strokeColor = textColor.CGColor;
}

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    _shapLayer.fillColor = fillColor.CGColor;
}


-(void)startAnimate
{
    self.fillColor = self.textColor;
    if (!_gradientLayer) {
        CAGradientLayer *layer = [[CAGradientLayer alloc] init];
        layer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 5);
        [self.layer addSublayer:layer];
        layer.mask = _shapLayer;
        _gradientLayer = layer;
    }
    
    _gradientLayer.colors = @[
                    (__bridge id)_shapLayer.strokeColor,
                    (__bridge id)_shapLayer.strokeColor,
                    (__bridge id)self.animateTinColor.CGColor,
                    (__bridge id)_shapLayer.strokeColor,
                    (__bridge id)_shapLayer.strokeColor];
    
    _gradientLayer.startPoint = CGPointMake(0, 1);
    _gradientLayer.endPoint = CGPointMake(1, 1);
    _gradientLayer.locations = @[@0, @(-TINCOLOR_PERSENT), @(-TINCOLOR_PERSENT/2.0), @0.0, @0.0];
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"locations"];
//    animate.fromValue = @[@0, @(-TINCOLOR_PERSENT), @(-TINCOLOR_PERSENT/2.0), @-0.0, @0.0];
    animate.duration = ANIMATE_TIME;
    animate.toValue = @[@0, @1.0, @(1+TINCOLOR_PERSENT/2.0), @(1+TINCOLOR_PERSENT), @2.0];
    animate.repeatCount = INT_MAX;
    animate.removedOnCompletion = NO;
    [_gradientLayer addAnimation:animate forKey:nil];
    
}

-(void)stopAnimate
{
    self.fillColor = [UIColor clearColor];
    [_gradientLayer removeAllAnimations];
    _gradientLayer.colors = @[(__bridge id)_shapLayer.strokeColor,(__bridge id)_shapLayer.strokeColor, (__bridge id)_shapLayer.strokeColor,(__bridge id)_shapLayer.strokeColor,(__bridge id)_shapLayer.strokeColor];
}



@end

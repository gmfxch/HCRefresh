//
//  HCRefreshFooterView.m
//  HCRefreshExample
//
//  Created by chenhao on 17/1/12.
//  Copyright © 2017年 chenhao. All rights reserved.
//

#import "HCRefreshFooterView.h"
#import "HCRefresh.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HCRefreshManager.h"


@interface HCRefreshFooterView()

@property(nonatomic, weak)UIScrollView  *superScrollView;
@property(nonatomic, assign)float       progress;

@end

@implementation HCRefreshFooterView
{
    UIView<HCRefreshCustomViewDelegate>  *customContentView;
    CAShapeLayer             *_shapLayer;
    UIActivityIndicatorView  *_activityView;
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
    @try {
         [self removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        
    } @finally {
    }
}

-(instancetype)initWithFrame:(CGRect)frame customContentView:(Class)customViewClass
{
    self = [super initWithFrame:frame customContentView:customViewClass];
    if (self) {
        
        [self addObserver];
        if (customViewClass) {
            
            UIView<HCRefreshCustomViewDelegate> *view = [[customViewClass alloc] initWithFrame:self.bounds];
            [self addSubview:view];
            customContentView = view;
            self.refreshState = HCRefreshState_Normal;
            return self;
        }
        
        //添加默认UI效果
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
        shapLayer.frame = self.bounds;
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:shapLayer];
        shapLayer.strokeColor = [HCRefreshManager shareManager].footerRefreshCircleColor.CGColor;
        shapLayer.lineWidth = 2.0;
        shapLayer.transform = CATransform3DMakeRotation(-M_PI/2.0, 0, 0, 1);
        _shapLayer = shapLayer;
        
        float size = self.bounds.size.height - 25;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.size.width/2.0 - size/2.0, self.bounds.size.height/2.0 - size/2.0, size, size)];
        _shapLayer.path = path.CGPath;
        _shapLayer.strokeEnd = 0;
        
    }
    return self;
}

-(void)addObserver
{
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGRect frame = self.frame;
    frame.origin.y = self.superScrollView.contentSize.height;
    self.frame = frame;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    customContentView.frame = self.bounds;
    float size = self.bounds.size.height - 25;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.size.width/2.0 - size/2.0, self.bounds.size.height/2.0 - size/2.0, size, size)];
    _shapLayer.path = path.CGPath;
    _shapLayer.strokeEnd = self.progress;
}


-(void)superScrollViewDidScroll
{
    if (!self.shouldBeginHandleScrollView) {
        return;
    }
    if (self.refreshState == HCRefreshState_StartRefresh) {
        self.progress = 1.0;
        return;
    }
    
    float dis = (self.superScrollView.contentOffset.y + self.superScrollView.bounds.size.height) - (self.superScrollView.contentSize.height + self.superScrollView.contentInset.bottom);
    if (dis > 0) {
        self.progress = dis/self.bounds.size.height;
    }else{
        self.progress = 0;
    }
    self.progress = MIN(self.progress, 1.0);
    
    HCRefreshState newState;
    if (self.progress >= 1.0) {
        //准备刷新
        newState = HCRefreshState_PrepareRefresh;
    }else{
        newState = HCRefreshState_Normal;
    }
    
    //更新状态
    if (self.refreshState != newState) {
        self.refreshState = newState;
    }
    
}

-(void)superScrollViewDidEndTouch
{
    if (self.progress >= 1.0) {
        //开始刷新
        if ((self.refreshState != HCRefreshState_StartRefresh) &&
            (self.superScrollView.hc_headerRefreshView.refreshState != HCRefreshState_StartRefresh)) {
            self.refreshState = HCRefreshState_StartRefresh;
        }
    }
}


-(void)setRefreshState:(HCRefreshState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (customContentView && [customContentView respondsToSelector:@selector(hcRefreshViewStateChangedWithNewState:)]) {
        [customContentView hcRefreshViewStateChangedWithNewState:refreshState];
    }
    
    if (refreshState == HCRefreshState_StartRefresh) {
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.superScrollView setContentInset:UIEdgeInsetsMake(self.superScrollView.contentInset.top, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom + self.bounds.size.height,self.superScrollView.contentInset.right)];
        }];
        
        if (self.actionTarget && self.actionSelector) {
            HCRefreshMsgSend((__bridge void *)self.actionTarget, self.actionSelector);
        }
        
        if (self.refreshActionBlock) {
            self.refreshActionBlock();
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _shapLayer.transform = CATransform3DScale(_shapLayer.transform, 0.1, 0.1, 0.1);
            _shapLayer.opacity = 0.5;
        } completion:^(BOOL finished) {
        }];
        _activityView = [self activityView];
        [_activityView startAnimating];
        _activityView.hidden = NO;
        _activityView.alpha = 1;
        

    }else if (refreshState == HCRefreshState_PrepareRefresh){
       
        
    }else{
        
    }
}

-(void)stopRefresh
{
    if (self.refreshState != HCRefreshState_StartRefresh) {
        return;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.superScrollView setContentInset:UIEdgeInsetsMake(self.superScrollView.contentInset.top, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom - self.bounds.size.height, self.superScrollView.contentInset.right)];
        _activityView.alpha = 0;
    } completion:^(BOOL finished) {
        self.refreshState = HCRefreshState_Normal;
        self.progress = 0;
        _shapLayer.opacity = 1;
        _shapLayer.transform = CATransform3DMakeRotation(-M_PI/2.0, 0, 0, 1);
        [_activityView stopAnimating];
    }];
}


#pragma mark set/get
-(UIScrollView*)superScrollView
{
    return (UIScrollView*)self.superview;
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    _shapLayer.strokeEnd = progress*progress;
    if (customContentView && [customContentView respondsToSelector:@selector(hcRefreshViewProgressChangedWithProgress:)]) {
        [customContentView hcRefreshViewProgressChangedWithProgress:progress];
    }
}

-(UIActivityIndicatorView*)activityView
{
    if (customContentView) {
        return nil;
    }
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.color = [HCRefreshManager shareManager].footerRefreshUIActivityIndicatorViewColor;
        _activityView.frame = CGRectMake(0, 0, 25, 25);
        _activityView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _activityView.hidesWhenStopped = YES;
        [self addSubview:_activityView];
    }
    return _activityView;
}

@end

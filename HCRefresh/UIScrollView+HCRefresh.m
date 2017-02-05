//
//  UIScrollView+HCRefresh.m
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git


#import "UIScrollView+HCRefresh.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HCRefreshHeaderView.h"
#import "HCRefreshManager.h"
#import "HCRefresh.h"

@interface UIScrollView()

@property(nonatomic, assign)BOOL     didAddObserver;

@end

@implementation UIScrollView (HCRefresh)

-(void)dealloc
{
    NSLog(@"%s",__func__);
    if (self.didAddObserver) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
        [self removeObserver:self forKeyPath:@"frame"];
    }
}

-(void)addObserver
{
    if (self.didAddObserver) {
        return;
    }
    self.didAddObserver = YES;
    
    [self.panGestureRecognizer addTarget:self action:@selector(panGestureSelector:)];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self updateFrame];
    }else{
        [self hc_scrollViewDidScroll];
    }
}

-(void)hc_addHeaderRefreshWithTarget:(id)target actionSelector:(SEL)headerSelector customHeaderView:(Class<HCRefreshCustomViewDelegate>)customHeaderView
{
    if (!self.superview) {
        return;
    }
    [self addObserver];
    HCRefreshHeaderView *view = [[HCRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -[HCRefreshManager shareManager].headerRefreshViewHeight-self.contentInset.top, CGRectGetWidth(self.bounds), [HCRefreshManager shareManager].headerRefreshViewHeight) customContentView:customHeaderView];
    [self addSubview:view];
    self.hc_headerRefreshView = view;
    self.hc_headerRefreshView.actionTarget = target;
    self.hc_headerRefreshView.actionSelector = headerSelector;
    
}


-(void)hc_addFooterRefreshWithTarget:(id)target actionSelector:(SEL)footerSelector customFooterView:(Class<HCRefreshCustomViewDelegate>)customFooterView
{
    if (!self.superview) {
        return;
    }
    [self addObserver];
    
    HCRefreshFooterView *view = [[HCRefreshFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, CGRectGetWidth(self.bounds), [HCRefreshManager shareManager].footerRefreshViewHeight) customContentView:customFooterView];
    [self addSubview:view];
    self.hc_footerRefreshView = view;
    self.hc_footerRefreshView.actionTarget = target;
    self.hc_footerRefreshView.actionSelector = footerSelector;
    
}

-(void)hc_addHeaderRefreshWithTarget:(id)target actionSelector:(SEL)headerSelector
{
    [self hc_addHeaderRefreshWithTarget:target actionSelector:headerSelector customHeaderView:nil];
}

-(void)hc_addFooterRefreshWithTarget:(id)target actionSelector:(SEL)footerSelector
{
    [self hc_addFooterRefreshWithTarget:target actionSelector:footerSelector customFooterView:nil];
}


-(void)hc_addHeaderRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock
{
    if (!self.superview) {
        return;
    }
    [self addObserver];
    
    HCRefreshHeaderView *view = [[HCRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -[HCRefreshManager shareManager].headerRefreshViewHeight-self.contentInset.top, CGRectGetWidth(self.bounds), [HCRefreshManager shareManager].headerRefreshViewHeight)];
    [self addSubview:view];
    self.hc_headerRefreshView = view;
    self.hc_headerRefreshView.refreshActionBlock = actionBlock;
}

-(void)hc_addFooterRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock
{
    if (!self.superview) {
        return;
    }
    [self addObserver];
    
    HCRefreshFooterView *view = [[HCRefreshFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, CGRectGetWidth(self.bounds), [HCRefreshManager shareManager].footerRefreshViewHeight)];
    [self addSubview:view];
    self.hc_footerRefreshView = view;
    self.hc_footerRefreshView.refreshActionBlock = actionBlock;
    
}


-(void)hc_startHeaderRefresh
{
    [self.hc_headerRefreshView startRefresh];
}

-(void)hc_stopHeaderRefresh
{
    [self.hc_headerRefreshView stopRefresh];
}

-(void)hc_stopHeaderRefreshAndShowMessage:(NSString*)message
{
    [self.hc_headerRefreshView stopHeaderRefreshAndShowMessage:message];
}

-(void)hc_stopFooterRefresh
{
    [self.hc_footerRefreshView stopRefresh];
}


-(void)updateFrame
{
    if (self.hc_headerRefreshView) {
        CGRect frame = self.hc_headerRefreshView.frame;
        frame.size.width = self.bounds.size.width;
        self.hc_headerRefreshView.frame = frame;
    }
    
    if (self.hc_footerRefreshView) {
        CGRect frame = self.hc_footerRefreshView.frame;
        frame.size.width = self.bounds.size.width;
        self.hc_footerRefreshView.frame = frame;
    }
}

#pragma mark -滚动事件
-(void)hc_scrollViewDidScroll
{
    [self.hc_headerRefreshView superScrollViewDidScroll];
    [self.hc_footerRefreshView superScrollViewDidScroll];
}

//scrollView滑动手势触发
-(void)panGestureSelector:(UIPanGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.hc_headerRefreshView) {
            self.hc_headerRefreshView.shouldBeginHandleScrollView = YES;
        }
        if (self.hc_footerRefreshView) {
            self.hc_footerRefreshView.shouldBeginHandleScrollView = YES;
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded||gesture.state==UIGestureRecognizerStateCancelled){
        if (self.hc_headerRefreshView) {
            [self.hc_headerRefreshView superScrollViewDidEndTouch];
        }
        if (self.hc_footerRefreshView) {
            [self.hc_footerRefreshView superScrollViewDidEndTouch];
        }
    }
}





#pragma mark -set/get
-(void)setHc_headerRefreshView:(HCRefreshHeaderView *)hc_headerRefreshView
{
    objc_setAssociatedObject(self, @"hc_headerRefreshView", hc_headerRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(HCRefreshHeaderView*)hc_headerRefreshView
{
    return objc_getAssociatedObject(self, @"hc_headerRefreshView");
}

-(void)setHc_footerRefreshView:(HCRefreshFooterView *)hc_footerRefreshView
{
    objc_setAssociatedObject(self, @"hc_footerRefreshView", hc_footerRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(HCRefreshFooterView*)hc_footerRefreshView
{
    return objc_getAssociatedObject(self, @"hc_footerRefreshView");
}

-(void)setDidAddObserver:(BOOL)didAddObserver
{
    objc_setAssociatedObject(self, @"didAddObserver", @(didAddObserver), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)didAddObserver
{
    return [objc_getAssociatedObject(self, @"didAddObserver") boolValue];
}



@end

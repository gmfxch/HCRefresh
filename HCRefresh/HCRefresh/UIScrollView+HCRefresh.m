//
//  UIScrollView+HCRefresh.m
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#define HEADER_HEIGHT   60.0

#import "UIScrollView+HCRefresh.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HCRefreshHeaderView.h"
#import "HCRefreshManager.h"
#import "HCRefresh.h"

@interface UIScrollView()

@property(nonatomic, weak)id     footerActionTarget;
@property(nonatomic, assign)SEL  footerActionSelector;
@property(nonatomic, assign)CGFloat  topInset;
@property(nonatomic, assign)BOOL     isOnFooterRefreshing;
@property(nonatomic, assign)BOOL     didAddObserver;
@property(nonatomic, copy)HCRefreshActionBlock footerActionBlock;

@end

@implementation UIScrollView (HCRefresh)

-(void)dealloc
{
    if (self.didAddObserver) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
        [self removeObserver:self forKeyPath:@"contentInset"];
    }
}

-(void)addObserver
{
    if (self.didAddObserver) {
        return;
    }
    self.didAddObserver = YES;
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([self.superview.nextResponder isKindOfClass:[UIViewController class]]) {
        
        UIViewController *ctrl = (UIViewController*)self.superview.nextResponder;
        if (ctrl.navigationController) {
            
            if (!ctrl.navigationController.isNavigationBarHidden && ctrl.automaticallyAdjustsScrollViewInsets) {
                self.topInset = 64;
            }
        }
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentInset"])
    {
        [self updateLayout];
    }
    else
    {
        [self hc_scrollViewDidScroll];
    }
}

-(void)hc_addHeaderRefreshWithTarget:(id)target actionSelector:(SEL)headerSelector
{
    if (!self.superview) {
        return;
    }
    
    [self addObserver];
    
    HCRefreshHeaderView *view = [[HCRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -HEADER_HEIGHT-self.contentInset.top + self.topInset, CGRectGetWidth(self.bounds), HEADER_HEIGHT)];
    [self addSubview:view];
    self.hc_headerRefreshView = view;
    self.hc_headerRefreshView.actionTarget = target;
    self.hc_headerRefreshView.actionSelector = headerSelector;
    
}


-(void)hc_addFooterRefreshWithTarget:(id)target actionSelector:(SEL)footerSelector
{
    [self addObserver];
    self.footerActionTarget = target;
    self.footerActionSelector = footerSelector;
}



-(void)hc_addHeaderRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock
{
    [self addObserver];
    
    HCRefreshHeaderView *view = [[HCRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -HEADER_HEIGHT-self.contentInset.top + self.topInset, CGRectGetWidth(self.bounds), HEADER_HEIGHT)];
    [self addSubview:view];
    self.hc_headerRefreshView = view;
    self.hc_headerRefreshView.headerActionBlock = actionBlock;
}

-(void)hc_addFooterRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock
{
    [self addObserver];
    self.footerActionBlock = actionBlock;
}


-(void)hc_startHeaderRefresh
{
    [self.hc_headerRefreshView startHeaderRefresh];
}

-(void)hc_stopHeaderRefresh
{
    [self.hc_headerRefreshView stopHeaderRefresh];
}

-(void)hc_stopHeaderRefreshAndShowMessage:(NSString*)message
{
    [self.hc_headerRefreshView stopHeaderRefreshAndShowMessage:message];
}

-(void)hc_stopFooterRefresh
{
    if (self.isOnFooterRefreshing) {
        self.isOnFooterRefreshing = NO;
    }
}

-(void)hc_setContentOffset:(CGPoint)contentOffset
{
    [self hc_setContentOffset:contentOffset];
    [self hc_scrollViewDidScroll];
}

-(void)hc_setContentInset:(UIEdgeInsets)contentInset
{
    [self hc_setContentInset:contentInset];
    [self updateLayout];
//    NSLog(@"%p, contentInset = %f", self ,contentInset.top);
}

#pragma mark -滚动事件
-(void)hc_scrollViewDidScroll
{
    
//    NSLog(@"%p, contentOffset = %f", self ,self.contentOffset.y);
    self.hc_headerRefreshView.superScrollViewOriginOffsetY = self.contentOffset.y;
    [self.hc_headerRefreshView superScrollViewDidScroll];
    
    if ((self.contentOffset.y + self.bounds.size.height + self.contentInset.bottom - [HCRefreshManager shareManager].footerRefreshHeight) >= (self.contentSize.height)
        &&(self.contentSize.height > self.bounds.size.height)
        &&!self.isOnFooterRefreshing
        &&!self.hc_headerRefreshView.isOnHeaderRefreshing)
    {
        self.isOnFooterRefreshing = YES;
        //传递消息
        if (self.footerActionTarget && self.footerActionSelector) {
            HCRefreshMsgSend((__bridge void *)self.footerActionTarget, self.footerActionSelector);
        }
        if (self.footerActionBlock) {
            self.footerActionBlock();
        }
    }
}

//更新布局
-(void)updateLayout
{
    if (self.hc_headerRefreshView.isOnHeaderRefreshing) {
        return;
    }
    
    self.topInset = 0;
    if ([self.superview.nextResponder isKindOfClass:[UIViewController class]]) {
        
        UIViewController *ctrl = (UIViewController*)self.superview.nextResponder;
        if (ctrl.navigationController) {
            
            if (!ctrl.navigationController.isNavigationBarHidden && ctrl.automaticallyAdjustsScrollViewInsets) {
                self.topInset = 64;
            }
        }
    }
    
    self.hc_headerRefreshView.frame = CGRectMake(0, -HEADER_HEIGHT-self.contentInset.top + self.topInset, CGRectGetWidth(self.bounds), HEADER_HEIGHT);
}


#pragma mark set/get
-(void)setHc_headerRefreshView:(HCRefreshHeaderView *)hc_headerRefreshView
{
    objc_setAssociatedObject(self, @"hc_headerRefreshView", hc_headerRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hc_headerRefreshView.topInset = self.topInset;
}
-(HCRefreshHeaderView*)hc_headerRefreshView
{
    return objc_getAssociatedObject(self, @"hc_headerRefreshView");
}


-(void)setFooterActionTarget:(id)footerActionTarget
{
    objc_setAssociatedObject(self, @"footerActionTarget", footerActionTarget, OBJC_ASSOCIATION_ASSIGN);
}
-(id)footerActionTarget
{
    return objc_getAssociatedObject(self, @"footerActionTarget");
}


-(void)setFooterActionSelector:(SEL)footerActionSelector
{
    objc_setAssociatedObject(self, @"footerActionSelector", NSStringFromSelector(footerActionSelector), OBJC_ASSOCIATION_COPY);
}
-(SEL)footerActionSelector
{
    NSString *selector = objc_getAssociatedObject(self, @"footerActionSelector");
    return NSSelectorFromString(selector);
}

-(void)setTopInset:(CGFloat)topInset
{
    objc_setAssociatedObject(self, @"topInset", @(topInset), OBJC_ASSOCIATION_ASSIGN);
    self.hc_headerRefreshView.topInset = topInset;
}
-(CGFloat)topInset
{
    return [objc_getAssociatedObject(self, @"topInset") floatValue];
}


-(void)setFooterActionBlock:(HCRefreshActionBlock)footerActionBlock
{
    objc_setAssociatedObject(self, @"footerActionBlock", footerActionBlock, OBJC_ASSOCIATION_COPY);
}

-(HCRefreshActionBlock)footerActionBlock
{
   return objc_getAssociatedObject(self, @"footerActionBlock");
}

-(void)setIsOnFooterRefreshing:(BOOL)isOnFooterRefreshing
{
     objc_setAssociatedObject(self, @"isOnFooterRefreshing", @(isOnFooterRefreshing), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)isOnFooterRefreshing
{
    return  [objc_getAssociatedObject(self, @"isOnFooterRefreshing") boolValue];
}


-(void)setDidAddObserver:(BOOL)didAddObserver
{
    objc_setAssociatedObject(self, @"didAddObserver", @(didAddObserver), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)didAddObserver
{
    return  [objc_getAssociatedObject(self, @"didAddObserver") boolValue];
}


@end

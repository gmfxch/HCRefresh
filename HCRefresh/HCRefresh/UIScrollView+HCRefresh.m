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
#import "NSObject+HCHook.h"
#import "HCRefreshManager.h"

@interface UIScrollView()

@property(nonatomic, weak)id     footerActionTarget;
@property(nonatomic, assign)SEL  footerActionSelector;
@property(nonatomic, assign)CGFloat  topInset;
@property(nonatomic, assign)BOOL     isOnFooterRefreshing;
@property(nonatomic, copy)HCRefreshActionBlock footerActionBlock;

@end

@implementation UIScrollView (HCRefresh)


-(void)hookSelector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        //监听滑动
        [self hc_hookSelector:@selector(setContentOffset:) withAfterBlock:^{
            
            [self hc_scrollViewDidScroll];
            
        }];
        
        //监听导航栏改变
        if ([self.superview.nextResponder isKindOfClass:[UIViewController class]]) {
            
            UIViewController *ctrl = (UIViewController*)self.superview.nextResponder;
            if (ctrl.navigationController) {
                
                if (!ctrl.navigationController.isNavigationBarHidden && ctrl.automaticallyAdjustsScrollViewInsets) {
                    self.topInset = 64;
                }
                
                [ctrl.navigationController hc_hookSelector:@selector(setNavigationBarHidden:animated:) withAfterBlock:^{
                    
                    [self updateLayout];
                    
                }];
                
            }
        }
        
        //监听inset
        [self hc_hookSelector:@selector(setContentInset:) withAfterBlock:^{
           
            [self updateLayout];
            
        }];
        
    });
}


-(void)hc_addHeaderRefreshWithTarget:(id)target actionSelector:(SEL)headerSelector
{
    if (!self.superview) {
        return;
    }
    
    [self hookSelector];
    
    HCRefreshHeaderView *view = [[HCRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -HEADER_HEIGHT-self.contentInset.top + self.topInset, CGRectGetWidth(self.bounds), HEADER_HEIGHT)];
    [self addSubview:view];
    self.hc_headerRefreshView = view;
    self.hc_headerRefreshView.actionTarget = target;
    self.hc_headerRefreshView.actionSelector = headerSelector;
    
}


-(void)hc_addFooterRefreshWithTarget:(id)target actionSelector:(SEL)footerSelector
{
    self.footerActionTarget = target;
    self.footerActionSelector = footerSelector;
}



-(void)hc_addHeaderRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock
{
    [self hookSelector];
    
    HCRefreshHeaderView *view = [[HCRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -HEADER_HEIGHT-self.contentInset.top + self.topInset, CGRectGetWidth(self.bounds), HEADER_HEIGHT)];
    [self addSubview:view];
    self.hc_headerRefreshView = view;
    self.hc_headerRefreshView.headerActionBlock = actionBlock;
}

-(void)hc_addFooterRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock
{
    if (actionBlock) {
        self.footerActionBlock = actionBlock;
    }
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

#pragma mark -滚动事件
-(void)hc_scrollViewDidScroll
{
    
    [self.hc_headerRefreshView superScrollViewDidScroll];
    
    if ((self.contentOffset.y + self.bounds.size.height + self.contentInset.bottom - [HCRefreshManager shareManager].footerRefreshHeight) >= (self.contentSize.height)
        &&(self.contentSize.height > self.bounds.size.height)
        &&!self.isOnFooterRefreshing
        &&!self.hc_headerRefreshView.isOnHeaderRefreshing)
    {
        self.isOnFooterRefreshing = YES;
        //传递消息
        if (self.footerActionTarget && self.footerActionSelector) {
            objc_msgSend(self.footerActionTarget, self.footerActionSelector);
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


@end

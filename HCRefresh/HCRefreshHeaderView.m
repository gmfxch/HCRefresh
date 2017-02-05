//
//  HCRefreshHeaderView.m
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git


#import "HCRefreshHeaderView.h"
#import "HCTextAnimateView.h"
#import "HCRefresh.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HCRefreshManager.h"


@interface HCRefreshHeaderView()

@property(nonatomic, weak)UIScrollView  *superScrollView;
@property(nonatomic, assign)float       progress;

@end

@implementation HCRefreshHeaderView
{
    UIView<HCRefreshCustomViewDelegate>       *customContentView;
    HCTextAnimateView  *animateView;
    UIEdgeInsets       superScrollViewOriInsert;
}

-(instancetype)initWithFrame:(CGRect)frame customContentView:(Class)customViewClass
{
    self = [super initWithFrame:frame customContentView:customViewClass];
    if (self) {
        self.backgroundColor = [UIColor  clearColor];
        self.clipsToBounds = NO;
        
        if (customViewClass) {
            UIView<HCRefreshCustomViewDelegate> *view = [[customViewClass alloc] initWithFrame:self.bounds];
            [self addSubview:view];
            customContentView = view;
            self.refreshState = HCRefreshState_Normal;
            return self;
        }
        //添加默认UI效果
        animateView = [[HCTextAnimateView alloc] initWithTitle:[HCRefreshManager shareManager].refreshTitle font:[HCRefreshManager shareManager].refreshTitleFont];
        animateView.textColor = [HCRefreshManager shareManager].refreshTitleColor;
        animateView.animateTinColor = [HCRefreshManager shareManager].refreshTitleTinColor;
        animateView.progress = 0;
        [self addSubview:animateView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    animateView.frame = self.bounds;
    customContentView.frame = self.bounds;
}

//scrollView滑动触发方法
-(void)superScrollViewDidScroll
{
    if (!self.shouldBeginHandleScrollView) {
        return;
    }
    if (self.refreshState == HCRefreshState_StartRefresh) {
        self.progress = 1.0;
        return;
    }
    float OffSetYWhenScrollTop = -self.superScrollView.contentInset.top;
    if (self.superScrollView.contentOffset.y < OffSetYWhenScrollTop){
        float dis = OffSetYWhenScrollTop - self.superScrollView.contentOffset.y;
        self.progress = dis/self.bounds.size.height;
        self.progress = MIN(1.0, self.progress);
    }else{
        self.progress = 0;
    }
    
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

//手指离开scrollView触发方法
-(void)superScrollViewDidEndTouch
{
    if (self.progress >= 1.0) {
        //开始刷新
        if ((self.refreshState != HCRefreshState_StartRefresh) &&
            (self.superScrollView.hc_footerRefreshView.refreshState != HCRefreshState_StartRefresh)) { //和底部刷新不可同时触发
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
    
    if (refreshState == HCRefreshState_StartRefresh)
    {
        [animateView startAnimate];
        superScrollViewOriInsert = self.superScrollView.contentInset;
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.superScrollView setContentInset:UIEdgeInsetsMake(superScrollViewOriInsert.top + CGRectGetHeight(self.bounds), superScrollViewOriInsert.left, superScrollViewOriInsert.right, superScrollViewOriInsert.bottom)];
            [self.superScrollView setContentOffset:CGPointMake(0, -superScrollViewOriInsert.top - CGRectGetHeight(self.bounds)) animated:NO];
        }];

        if (self.actionTarget && self.actionSelector) {
            HCRefreshMsgSend((__bridge void *)self.actionTarget, self.actionSelector);
        }
        
        if (self.refreshActionBlock) {
            self.refreshActionBlock();
        }
    }
    else if (refreshState == HCRefreshState_PrepareRefresh)
    {
        animateView.fillColor = animateView.textColor;
    }
    else
    {
        animateView.fillColor = [UIColor clearColor];
    }
    
}

#pragma mark -action
-(void)startRefresh
{
    if (self.refreshState == HCRefreshState_StartRefresh) {
        return;
    }
    self.progress = 1.0;
    self.refreshState = HCRefreshState_StartRefresh;
}

-(void)stopRefresh
{
    if (self.refreshState != HCRefreshState_StartRefresh) {
        return;
    }
    UIEdgeInsets inset = self.superScrollView.contentInset;
    [UIView animateWithDuration:0.4 animations:^{
        [self.superScrollView setContentInset:UIEdgeInsetsMake(inset.top - CGRectGetHeight(self.bounds), inset.left, inset.right, inset.bottom)];
    } completion:^(BOOL finished) {
        self.refreshState = HCRefreshState_Normal;
        self.progress = 0;
    }];
    
    [animateView stopAnimate];
}

-(void)stopHeaderRefreshAndShowMessage:(NSString*)message
{
    if (self.refreshState != HCRefreshState_StartRefresh) {
        return;
    }
    
    UIView  *view = self.superview.superview;
    UIEdgeInsets inset = self.superScrollView.contentInset;
    [UIView animateWithDuration:0.5 animations:^{
        [self.superScrollView setContentInset:UIEdgeInsetsMake(inset.top - CGRectGetHeight(self.bounds), inset.left, inset.right, inset.bottom)];
    } completion:^(BOOL finished) {
        
        self.refreshState = HCRefreshState_Normal;
        float height = 25;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(view.frame) - height + self.superScrollView.contentInset.top, self.bounds.size.width, height)];
        label.backgroundColor = [HCRefreshManager shareManager].finishRefreshInfoTitleBackgroundColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [HCRefreshManager shareManager].finishRefreshInfoTitleColor;
        label.font = [UIFont systemFontOfSize:14];
        label.text = message;
        label.alpha = 0.1;
        [view addSubview:label];
        [UIView animateWithDuration:0.3 animations:^{
            label.transform = CGAffineTransformMakeTranslation(0, height);
            label.alpha = 1.0;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25  animations:^{
                label.transform = CGAffineTransformIdentity;
                label.alpha = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
            
        });
        
    }];
    
    [animateView stopAnimate];
}


#pragma mark set/get
-(UIScrollView*)superScrollView
{
    return (UIScrollView*)self.superview;
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    animateView.progress = progress * progress;
    if (customContentView && [customContentView respondsToSelector:@selector(hcRefreshViewProgressChangedWithProgress:)]) {
        [customContentView hcRefreshViewProgressChangedWithProgress:progress];
    }
}


@end

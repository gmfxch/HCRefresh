//
//  HCRefreshHeaderView.m
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
////  代码地址：https://github.com/gmfxch/HCRefresh.git


#import "HCRefreshHeaderView.h"
#import "HCTextAnimateView.h"
#import "HCRefresh.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HCRefreshManager.h"


@interface HCRefreshHeaderView()

@property(nonatomic, weak)UIScrollView  *superScrollView;
@property(nonatomic, assign)BOOL        isPrepareRefreshing;

@end

@implementation HCRefreshHeaderView
{
    CGFloat   lastOffsetY;
    CGFloat   moveY;
    HCTextAnimateView  *animateView;
    UIEdgeInsets       superScrollViewOriInsert;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor  clearColor];
        self.clipsToBounds = NO;
        self.refreshState = HCRefreshState_Normal;
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
}


-(void)superScrollViewDidScroll
{
    
    if (self.superScrollView.isDragging) {
        //此变量为了防止superScrollView刚显示出来就开始刷新的bug
        self.superScrollViewDidTouch = YES;
    }
    
    if (!self.superScrollViewDidTouch) {
        lastOffsetY = self.superScrollView.contentOffset.y;
        return;
    }
  
    float progress = 0;
    float OffSetYWhenScrollTop = -self.superScrollView.contentInset.top;
    if (self.superScrollView.contentOffset.y < OffSetYWhenScrollTop && self.superScrollView.isDragging) {
        
        moveY += lastOffsetY - self.superScrollView.contentOffset.y;
        progress = moveY / CGRectGetHeight(self.bounds);
        progress = progress <= 1.0 ? progress : 1.0;
        
    }else{
        
        moveY = 0;
    }
    
    animateView.progress = progress * progress * progress * progress;
    lastOffsetY = self.superScrollView.contentOffset.y;
    
    
    HCRefreshState  newState;
    if (progress >= 1.0){
        if (self.superScrollView.isDragging){
            //手指未松开
            newState = HCRefreshState_PrepareRefresh;
            self.isPrepareRefreshing = YES;
        }
        else{
            newState = HCRefreshState_StartRefresh;
        }
    }else{
        if (self.isPrepareRefreshing && !self.superScrollView.isDragging) {
            newState = HCRefreshState_StartRefresh;
        }else{
            newState = HCRefreshState_Normal;
            self.isPrepareRefreshing = NO;
        }
    }
    
    if (newState != self.refreshState) {
        self.refreshState = newState;
    }
    
    
}


-(void)setRefreshState:(HCRefreshState)refreshState
{
    _refreshState = refreshState;
    
    if (self.isOnHeaderRefreshing) {
        return;
    }
    
    if (refreshState == HCRefreshState_StartRefresh)
    {
        self.isOnHeaderRefreshing = YES;
        [animateView startAnimate];
        superScrollViewOriInsert = self.superScrollView.contentInset;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.superScrollView setContentInset:UIEdgeInsetsMake(superScrollViewOriInsert.top + CGRectGetHeight(self.bounds), superScrollViewOriInsert.left, superScrollViewOriInsert.right, superScrollViewOriInsert.bottom)];
            [self.superScrollView setContentOffset:CGPointMake(0, -superScrollViewOriInsert.top - CGRectGetHeight(self.bounds)) animated:NO];
        }];

        
        //
        if (self.actionTarget && self.actionSelector) {
            HCRefreshMsgSend((__bridge void *)self.actionTarget, self.actionSelector);
        }
        
        if (self.headerActionBlock) {
            self.headerActionBlock();
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
-(void)startHeaderRefresh
{
    if (self.isOnHeaderRefreshing) {
        return;
    }
    self.isOnHeaderRefreshing = YES;
    self.superScrollViewDidTouch = YES;
    animateView.progress = 1.0;
    [animateView startAnimate];
    superScrollViewOriInsert = self.superScrollView.contentInset;
    [UIView animateWithDuration:0.3 animations:^{
        [self.superScrollView setContentInset:UIEdgeInsetsMake(superScrollViewOriInsert.top + CGRectGetHeight(self.bounds) , superScrollViewOriInsert.left, superScrollViewOriInsert.right, superScrollViewOriInsert.bottom)];
        [self.superScrollView setContentOffset:CGPointMake(0, -superScrollViewOriInsert.top - CGRectGetHeight(self.bounds)) animated:NO];
    }];
    
    //
    if (self.actionTarget && self.actionSelector) {
        HCRefreshMsgSend((__bridge void *)self.actionTarget, self.actionSelector);
    }
    
    if (self.headerActionBlock) {
        self.headerActionBlock();
    }
    
}

-(void)stopHeaderRefresh
{
    if (!self.isOnHeaderRefreshing) {
        return;
    }
    
    UIEdgeInsets inset = self.superScrollView.contentInset;
    [UIView animateWithDuration:0.5 animations:^{
        [self.superScrollView setContentInset:UIEdgeInsetsMake(inset.top - CGRectGetHeight(self.bounds), inset.left, inset.right, inset.bottom)];
    } completion:^(BOOL finished) {
        self.isOnHeaderRefreshing = NO;
    }];
    
    [animateView stopAnimate];
}

-(void)stopHeaderRefreshAndShowMessage:(NSString*)message
{
    if (!self.isOnHeaderRefreshing) {
        return;
    }
    self.isOnHeaderRefreshing = NO;
    
    UIView  *view = self.superview.superview;
    UIEdgeInsets inset = self.superScrollView.contentInset;
    [UIView animateWithDuration:0.5 animations:^{
        [self.superScrollView setContentInset:UIEdgeInsetsMake(inset.top - CGRectGetHeight(self.bounds), inset.left, inset.right, inset.bottom)];
    } completion:^(BOOL finished) {
        
        float height = 25;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(view.frame) + self.topInset - height, self.bounds.size.width, height)];
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


@end

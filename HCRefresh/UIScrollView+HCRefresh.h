//
//  UIScrollView+HCRefresh.h
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git

#import <UIKit/UIKit.h>
#import "HCRefreshBaseView.h"
#import "HCRefreshHeaderView.h"
#import "HCRefreshFooterView.h"


@interface UIScrollView (HCRefresh)

@property(nonatomic, strong)HCRefreshHeaderView  *hc_headerRefreshView;
@property(nonatomic, strong)HCRefreshFooterView  *hc_footerRefreshView;

/**
 * 添加刷新
 */
-(void)hc_addHeaderRefreshWithTarget:(id)target actionSelector:(SEL)headerSelector;
-(void)hc_addFooterRefreshWithTarget:(id)target actionSelector:(SEL)footerSelector;

/**
 * 添加刷新，并自定义刷新视图View
 */
-(void)hc_addHeaderRefreshWithTarget:(id)target actionSelector:(SEL)headerSelector customHeaderView:(Class<HCRefreshCustomViewDelegate>)customHeaderView;
-(void)hc_addFooterRefreshWithTarget:(id)target actionSelector:(SEL)footerSelector customFooterView:(Class<HCRefreshCustomViewDelegate>)customFooterView;

/**
 * 添加刷新（block方式）
 */
-(void)hc_addHeaderRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock;
-(void)hc_addFooterRefreshWithActionBlock:(HCRefreshActionBlock)actionBlock;

/**
 * 开始下拉刷新
 */
-(void)hc_startHeaderRefresh;

/**
 * 停止下拉刷新
 */
-(void)hc_stopHeaderRefresh;

/**
 * 停止下拉刷新，然后显示更新信息（比如“更新了5条新闻”）
 */
-(void)hc_stopHeaderRefreshAndShowMessage:(NSString*)message;

/**
 * 停止上拉刷新
 */
-(void)hc_stopFooterRefresh;

@end

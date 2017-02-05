//
//  HCRefreshManager.h
//  HCRefresh
//
//  Created by chenhao on 16/10/19.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HCRefreshManager : NSObject


/**
 * 顶部刷新视图的高度（默认60像素）
 */
@property (nonatomic, assign)  CGFloat        headerRefreshViewHeight;

/**
 * 底部刷新视图的高度（默认50像素）
 */
@property (nonatomic, assign)  CGFloat        footerRefreshViewHeight;

/**
 * 顶部显示的刷新文字内容（默认：“HCRefresh”）
 */
@property (nonatomic, copy)   NSString        *refreshTitle;

/**
 * 顶部刷新文字的颜色（默认灰色）
 */
@property (nonatomic, strong) UIColor         *refreshTitleColor;

/**
 * 顶部刷新文字在显示动画时的高亮颜色（默认白色）
 */
@property (nonatomic, strong) UIColor         *refreshTitleTinColor;

/**
 * 顶部刷新文字的字体（默认系统加粗字体24号）
 */
@property (nonatomic, strong) UIFont          *refreshTitleFont;


/**
 * 停止下拉刷新后显示更新信息label的颜色（例如“更新了10条信息”，默认白色）
 */
@property (nonatomic, strong) UIColor         *finishRefreshInfoTitleColor;

/**
 * 停止下拉刷新后显示更新信息label的背景颜色（默认黄色）
 */
@property (nonatomic, strong) UIColor         *finishRefreshInfoTitleBackgroundColor;

/**
 * 上拉加载圆环颜色（默认灰色）
 */
@property (nonatomic, strong) UIColor         *footerRefreshCircleColor;
/**
 * 上拉加载UIActivityIndicatorView颜色（默认灰色）
 */
@property (nonatomic, strong) UIColor         *footerRefreshUIActivityIndicatorViewColor;


+(HCRefreshManager*)shareManager;

@end

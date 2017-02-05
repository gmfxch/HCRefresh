//
//  ViewController.m
//  HCRefresh
//
//  Created by chenhao on 16/10/18.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git

#import "ViewController.h"
#import "HCRefresh.h"
#import "HCRefreshManager.h"
#import "CustomRefreshView.h"

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController
{
    UIScrollView  *_scrollView;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    self.title = @"HCRefresh";
    self.view.backgroundColor = HC_UICOLOR_RGB(41, 47, 56);
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height + 300);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;

    
    //*********自定义刷新显示内容(可选)*********
    [HCRefreshManager shareManager].refreshTitleColor = HC_UICOLOR_RGB(100, 100, 100);
    [HCRefreshManager shareManager].refreshTitle = @"HCREFRESH";
    [HCRefreshManager shareManager].refreshTitleFont = [UIFont boldSystemFontOfSize:24];
    [HCRefreshManager shareManager].refreshTitleTinColor = HC_UICOLOR_RGB(255, 255, 255);
    
    
    //*********添加下拉刷新*********
    [scrollView hc_addHeaderRefreshWithTarget:self actionSelector:@selector(headerRefresh) customHeaderView:nil];
    
    //*********添加上拉刷新*********
    [scrollView hc_addFooterRefreshWithTarget:self actionSelector:@selector(footerRefresh)];
    
    //*********添加上拉刷新（自定义刷新视图UI）*********
//    [scrollView hc_addFooterRefreshWithTarget:self actionSelector:@selector(footerRefresh) customFooterView:[CustomRefreshView class]];
}


-(void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止下拉刷新（不显示更新信息）
        [_scrollView hc_stopHeaderRefresh];
        
        //停止下拉刷新（显示更新信息）
//        [_scrollView hc_stopHeaderRefreshAndShowMessage:@"更新了10条信息"];
        
    });
}

-(void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止底部刷新
        [_scrollView hc_stopFooterRefresh];
    });
}

@end

//
//  ViewController.m
//  HCRefresh
//
//  Created by chenhao on 16/10/18.
//  Copyright © 2016年 chenhao. All rights reserved.
////  代码地址：https://github.com/gmfxch/HCRefresh.git

#import "ViewController.h"
#import "HCRefresh.h"
#import "HCRefreshManager.h"

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
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 200)];
    bgImageView.backgroundColor = [UIColor grayColor];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(bgImageView.bounds));
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:bgImageView];
    _scrollView = scrollView;
    
    //*********自定义刷新显示内容(可选)*********
    [HCRefreshManager shareManager].refreshTitleColor = HC_UICOLOR_RGB(100, 100, 100);
    [HCRefreshManager shareManager].refreshTitle = @"HCRefresh";
    [HCRefreshManager shareManager].refreshTitleFont = [UIFont boldSystemFontOfSize:24];
    [HCRefreshManager shareManager].refreshTitleTinColor = HC_UICOLOR_RGB(255, 255, 255);
    [HCRefreshManager shareManager].footerRefreshHeight = 0;

    
    //*********添加刷新（selector方式）*********
    [scrollView hc_addHeaderRefreshWithTarget:self actionSelector:@selector(headerRefresh)];
    [scrollView hc_addFooterRefreshWithTarget:self actionSelector:@selector(footerRefresh)];

}


-(void)headerRefresh
{
    NSLog(@"headerRefresh");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止下拉刷新（不显示更新信息）
        //[_scrollView hc_stopHeaderRefresh];
        
        //停止下拉刷新（显示更新信息）
        [_scrollView hc_stopHeaderRefreshAndShowMessage:@"更新了10条信息"];
        
    });
}

-(void)footerRefresh
{
    NSLog(@"footerRefresh");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止底部刷新
        [_scrollView hc_stopFooterRefresh];
    });
}

@end

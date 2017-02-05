//
//  HCRefreshManager.m
//  HCRefresh
//
//  Created by chenhao on 16/10/19.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git

#import "HCRefreshManager.h"
#import "HCRefresh.h"

@implementation HCRefreshManager

+(HCRefreshManager*)shareManager
{
    static HCRefreshManager *manager = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HCRefreshManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.headerRefreshViewHeight = 60;
        self.footerRefreshViewHeight = 50;
        self.refreshTitle = @"HCREFRESH";
        self.refreshTitleFont = [UIFont boldSystemFontOfSize:24];
        self.refreshTitleColor = HC_UICOLOR_RGB(150, 150, 150);
        self.refreshTitleTinColor = HC_UICOLOR_RGB(255, 255, 255);
        self.finishRefreshInfoTitleColor = [UIColor whiteColor];
        self.finishRefreshInfoTitleBackgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.7];
        self.footerRefreshUIActivityIndicatorViewColor = [UIColor grayColor];
        self.footerRefreshCircleColor = [UIColor grayColor];
        
    }
    return self;
}

@end

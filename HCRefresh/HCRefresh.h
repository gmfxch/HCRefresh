//
//  HCRefreshControl.h
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git

#define HC_UICOLOR_RGB(R,G,B) ([UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0])
#define HCRefreshMsgSend(...) ((void (*)(void *, SEL))objc_msgSend)(__VA_ARGS__)

#ifndef HCRefreshControl_h
#define HCRefreshControl_h

#import "UIScrollView+HCRefresh.h"
#import "HCRefreshBaseView.h"


#endif /* HCRefreshControl_h */

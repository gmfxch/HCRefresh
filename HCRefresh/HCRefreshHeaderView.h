//
//  HCRefreshHeaderView.h
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//  代码地址：https://github.com/gmfxch/HCRefresh.git

#import <UIKit/UIKit.h>
#import "HCRefreshBaseView.h"


@interface HCRefreshHeaderView : HCRefreshBaseView


-(void)stopHeaderRefreshAndShowMessage:(NSString*)message;

@end

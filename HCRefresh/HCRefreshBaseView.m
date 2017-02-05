//
//  HCRefreshBaseView.m
//  HCRefreshExample
//
//  Created by chenhao on 17/1/12.
//  Copyright © 2017年 chenhao. All rights reserved.
//

#import "HCRefreshBaseView.h"

@implementation HCRefreshBaseView

-(instancetype)initWithFrame:(CGRect)frame customContentView:(Class)customViewClass
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)superScrollViewDidScroll{}
-(void)superScrollViewDidEndTouch{}

-(void)startRefresh{}
-(void)stopRefresh{}



@end

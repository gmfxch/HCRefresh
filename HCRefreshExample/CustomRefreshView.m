//
//  CustomFooterView.m
//  HCRefreshExample
//
//  Created by chenhao on 17/1/13.
//  Copyright © 2017年 chenhao. All rights reserved.
//

#import "CustomRefreshView.h"

@implementation CustomRefreshView
{
    UILabel *titleLabel;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        titleLabel = label;
        
    }
    return self;
}

#pragma mark -HCRefreshCustomViewDelegate代理
-(void)hcRefreshViewProgressChangedWithProgress:(float)progress
{
    self.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:progress];
}

-(void)hcRefreshViewStateChangedWithNewState:(HCRefreshState)newState
{
    switch (newState) {
            
        case HCRefreshState_Normal: //常规状态
        {
           titleLabel.text = @"上拉加载更多";
        }
            break;
            
        case HCRefreshState_PrepareRefresh: //准备刷新状态
        {
           titleLabel.text = @"松开即可刷新";
        }
            break;
            
        case HCRefreshState_StartRefresh:  //正在刷新状态
        {
            titleLabel.text = @"正在刷新";
        }
            break;
            
        default:
            break;
    }
}

@end

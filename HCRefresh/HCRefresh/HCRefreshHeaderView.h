//
//  HCRefreshHeaderView.h
//  HCRefreshControl
//
//  Created by chenhao on 16/10/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//
typedef void(^HCRefreshActionBlock)();

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HCRefreshState){
   
   HCRefreshState_Normal,
   HCRefreshState_PrepareRefresh,
   HCRefreshState_StartRefresh

};

@interface HCRefreshHeaderView : UIView

@property (nonatomic, assign) HCRefreshState  refreshState;
@property (nonatomic, assign) BOOL            superScrollViewDidTouch;
@property (nonatomic, assign) BOOL            isOnHeaderRefreshing;
@property (nonatomic, weak) id                actionTarget;
@property (nonatomic, assign) SEL             actionSelector;
@property (nonatomic, assign) CGFloat         topInset;
@property (nonatomic, assign) CGFloat         superScrollViewOriginOffsetY;
@property (nonatomic, copy) HCRefreshActionBlock headerActionBlock;


-(void)superScrollViewDidScroll;

//刷新方法
-(void)startHeaderRefresh;
-(void)stopHeaderRefresh;
-(void)stopHeaderRefreshAndShowMessage:(NSString*)message;

@end

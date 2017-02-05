//
//  HCRefreshBaseView.h
//  HCRefreshExample
//
//  Created by chenhao on 17/1/12.
//  Copyright © 2017年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HCRefreshActionBlock)();

typedef NS_ENUM(NSUInteger, HCRefreshState){
    
    HCRefreshState_Normal,
    HCRefreshState_PrepareRefresh,
    HCRefreshState_StartRefresh
    
};

@protocol HCRefreshCustomViewDelegate <NSObject>

@optional
/**
 刷新状态更新回调
 */
-(void)hcRefreshViewStateChangedWithNewState:(HCRefreshState)newState;
/**
 下拉/上拉 进度回调（ 0 ~ 1 ）
 */
-(void)hcRefreshViewProgressChangedWithProgress:(float)progress;

@end

@interface HCRefreshBaseView : UIView

@property (nonatomic, assign) HCRefreshState  refreshState;
@property (nonatomic, assign) BOOL            shouldBeginHandleScrollView;
@property (nonatomic, weak) id                actionTarget;
@property (nonatomic, assign) SEL             actionSelector;
@property (nonatomic, copy) HCRefreshActionBlock refreshActionBlock;

-(instancetype)initWithFrame:(CGRect)frame  customContentView:(Class)customViewClass;

-(void)superScrollViewDidScroll;
-(void)superScrollViewDidEndTouch;

-(void)startRefresh;
-(void)stopRefresh;

@end

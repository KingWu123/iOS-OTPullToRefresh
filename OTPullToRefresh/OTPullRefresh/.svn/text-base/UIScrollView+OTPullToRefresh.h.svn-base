//
//  UIScrollView+OTPullToRefresh.h
//  OTPullToRefresh
//
//  Created by king.wu on 1/29/15.
//  Copyright (c) 2015 king.wu. All rights reserved.
//

/* 扩展scrollView,使其具有 下拉刷新 和上拉加载更多的 功能。由于这个功能的实现是通过设置
 * scrollView的contentInset来实现的，所以如果在外部 修改了 conentInset，可能会导致 界面混乱
*/

#import <UIKit/UIKit.h>
#import "OTPullDownRefreshView.h"
#import "OTPullUpRefreshView.h"


/**
 *  "下拉"刷新的类型
 */
typedef  NS_ENUM(NSUInteger, OTPullDownRefreshType)
{
    OTPullDownRefreshTypeDefault, //最常用的 下拉刷新
};


/**
 *  "上拉"刷新的类型
 */
typedef  NS_ENUM(NSUInteger, OTPullUpRefreshType)
{
    OTPullUpRefreshTypeDefault, //最常用的 上拉刷新
};



/**
 *  这个类用于给scrollView添加下拉、上拉时的刷新处理
 */
@interface UIScrollView (OTPullToRefresh)


/*-----------------------以下是 "下拉" 的 功能接口 ---------------*/

/**
 *  添加顶部"下拉"操作
 *
 *  @param handler 用于处理下拉后需要处理的事件。
 *  @param type  下拉刷新的 展示类型。
 */
- (void)addPullDownRefreshWithAction:(OTPullActionHandler)handler type:(OTPullDownRefreshType)type;


/**
 *  删除顶部 "下拉" 操作
 *
 */
- (void)removePullDownRefresh;


/**
 *  自动触发 “下拉” 刷新动作,常用在 viewWillAppear处
 */
- (void)autoTriggerPullDownRefresh;

/**
 *  “下拉” 刷新完成后的处理
 */
- (void)pullDownRefreshDataSuccess:(BOOL)isSuccess;


/**
 *  下拉 刷新是否正在进行。
 *
 *  @return 返回 下拉 刷新是否正在进行的值
 */
- (BOOL)isPullDownRefreshExcuting;



/*-----------------------以下是 "上拉" 的 功能接口 ---------------*/

/**
 *  添加 底部"上拉" 操作
 *
 *  @param handler  用于处理上拉后需要处理的事件。
 *  @param type  上拉刷新的 展示类型。
 */
- (void)addPullUpRefreshWithAction:(OTPullActionHandler)handler type:(OTPullUpRefreshType)type;


/**
 *  删除底部 "上拉" 操作
 *
 */
- (void)removePullUpRefresh;


/**
 *  “上拉” 刷新完成后的处理
 */
- (void)pullUpRefreshDataSuccess:(BOOL)isSuccess;

/**
 *  上拉 刷新是否正在进行。
 *
 *  @return 返回 上拉 刷新是否正在进行的值
 */
- (BOOL)isPullUpRefreshExcuting;

@end

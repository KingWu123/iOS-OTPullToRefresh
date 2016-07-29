//
//  UIScrollView+OTPullToRefresh.m
//  OTPullToRefresh
//
//  Created by king.wu on 1/29/15.
//  Copyright (c) 2015 king.wu. All rights reserved.
//

#import "UIScrollView+OTPullToRefresh.h"
#import <objc/runtime.h>


#define OTPullDownDefualtRefreshViewTag 13333

#define OTPullUpDefualtRefreshViewTag 23333

@implementation UIScrollView (OTPullToRefresh)


/**
 *  添加顶部下拉操作
 *
 *  @param handler 用于处理下拉后需要处理的事件。
 */
- (void)addPullDownRefreshWithAction:(OTPullActionHandler)handler type:(OTPullDownRefreshType)type
{
   
    if ([self viewWithTag:OTPullDownDefualtRefreshViewTag] == nil)//如果view没初始化，就初始化一个view
    {
        OTPullDownRefreshView *view = [[OTPullDownRefreshView alloc] initWithFrame:CGRectMake(0, -1 * OTPullDownRefreshViewHEIGHT, self.bounds.size.width, OTPullDownRefreshViewHEIGHT)];
        
        view.tag = OTPullDownDefualtRefreshViewTag;
        
        view.actionHandler = handler;
        view.scrollView = self;
        view.originalScrollViewInset = self.contentInset;
        
        [self addSubview:view];
    }

    
}

/**
 *  删除顶部 "下拉" 操作 --todo--
 *
 */
- (void)removePullDownRefresh
{
   
    OTPullRefreshBaseView *refreshView = (OTPullRefreshBaseView *)[self viewWithTag:OTPullDownDefualtRefreshViewTag];
    if (refreshView != nil)
    {
        [refreshView removeFromSuperview];
    }
    
}


/**
 *  自动触发 “下拉” 刷新动作
 */
- (void)autoTriggerPullDownRefresh
{
    OTPullRefreshBaseView *refresh = (OTPullRefreshBaseView *)[self viewWithTag:OTPullDownDefualtRefreshViewTag];
    
    [refresh autoStartRefresh];
}

/**
 *  “下拉” 刷新完成后的处理
 */
- (void)pullDownRefreshDataSuccess:(BOOL)isSuccess
{
    OTPullRefreshBaseView *refresh = (OTPullRefreshBaseView *)[self viewWithTag:OTPullDownDefualtRefreshViewTag];
    [refresh stopRefresh:isSuccess];
}

/**
 *  下拉 刷新是否正在进行。
 *
 *  @return 返回 下拉 刷新是否正在进行的值
 */
- (BOOL)isPullDownRefreshExcuting
{
    OTPullRefreshBaseView *refresh = (OTPullRefreshBaseView *)[self viewWithTag:OTPullDownDefualtRefreshViewTag];
    return [refresh isPullRefreshExcuting];
}

/*-----------------------以下是 "上拉" 的 功能接口 ---------------*/


/**
 *  添加 底部"上拉" 操作
 *
 *  @param handler  用于处理上拉后需要处理的事件。
 */
- (void)addPullUpRefreshWithAction:(OTPullActionHandler)handler type:(OTPullUpRefreshType)type
{
    if ([self viewWithTag:OTPullUpDefualtRefreshViewTag] == nil)//如果view没初始化，就初始化一个view
    {
        OTPullUpRefreshView *view = [[OTPullUpRefreshView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, OTPullUpRefreshViewHEIGHT)];
        
        view.tag = OTPullUpDefualtRefreshViewTag;
        
        view.actionHandler = handler;
        view.scrollView = self;
        view.originalScrollViewInset = self.contentInset;
        
        //这个要在上面的语句初始化完后写
        [view setScrollViewContentInsetForLoading];

        [self addSubview:view];
    }
}


/**
 *  删除底部 "上拉" 操作 --todo--
 *
 */
- (void)removePullUpRefresh
{
    OTPullRefreshBaseView *refreshView = (OTPullRefreshBaseView *)[self viewWithTag:OTPullUpDefualtRefreshViewTag];
    if (refreshView != nil)
    {
        [refreshView removeFromSuperview];
    }

}


/**
 *  “上拉” 刷新完成后的处理
 */
- (void)pullUpRefreshDataSuccess:(BOOL)isSuccess
{
    OTPullRefreshBaseView *refresh = (OTPullRefreshBaseView *)[self viewWithTag:OTPullUpDefualtRefreshViewTag];
    [refresh stopRefresh:isSuccess];
}



/**
 *  上拉 刷新是否正在进行。
 *
 *  @return 返回 上拉 刷新是否正在进行的值
 */
- (BOOL)isPullUpRefreshExcuting
{
     OTPullRefreshBaseView *refresh = (OTPullRefreshBaseView *)[self viewWithTag:OTPullUpDefualtRefreshViewTag];
    return  [refresh isPullRefreshExcuting];
}

//
//
//#pragma mark - set_get method
//
////设置TopPullDownRefreshView
//- (void)setTopPullDownRefreshView:(OTPullDownRefreshView *)pullRefreshView
//{
//    [self willChangeValueForKey:@"topPullDownRefreshView"];
//    
//    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
//                             pullRefreshView,
//                             OBJC_ASSOCIATION_ASSIGN);
//    [self didChangeValueForKey:@"topPullDownRefreshView"];
//}
//
////获取TopPullDownRefreshView
//- (OTPullDownRefreshView *)topPullDownRefreshView
//{
//    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
//}

@end

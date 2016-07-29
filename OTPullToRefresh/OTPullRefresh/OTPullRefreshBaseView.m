//
//  OTPullRefreshBaseView.m
//  OTPullToRefresh
//
//  Created by king.wu on 1/30/15.
//  Copyright (c) 2015 king.wu. All rights reserved.
//

#import "OTPullRefreshBaseView.h"

@interface OTPullRefreshBaseView ()

@end

@implementation OTPullRefreshBaseView

/**
 *  自动开始刷新，一般用于第一次进入页面时的下拉更新，由子类自己实现
 */
- (void)autoStartRefresh
{
}

/**
 *  停止刷新， 由子类自己实现
 *
 *  @param isSuccess 表示数据刷新成功还是失败
 */
- (void)stopRefresh:(BOOL)isSuccess;

{
}

/**
 *   刷新是否正在进行。
 *
 *  @return 返回 刷新是否正在进行的值
 */
- (BOOL)isPullRefreshExcuting
{
    return NO;
}


- (void)dealloc
{
    self.scrollView.delegate = nil;
    [self removeKVO];
}


#pragma mark - set/get method

/**
 *  在设置scrollView的时候，监听它的contentOffset、contentSize和frame
 */
- (void)setScrollView:(UIScrollView *)scrollView
{
    [self removeKVO];
    _scrollView = scrollView;
    [self addKVO];
  
}


/**
 *  移除 对scrollView的 kvo 监听
 */
- (void)removeKVO
{
    
    if (self.scrollView != nil) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
        [self.scrollView removeObserver:self forKeyPath:@"frame"];
    }
}

/**
 *  加入 对scrollView的 kvo 监听
 */
- (void)addKVO
{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}



@end

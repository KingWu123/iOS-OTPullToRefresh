//
//  OTPullRefreshBaseView.h
//  OTPullToRefresh
//
//  Created by king.wu on 1/30/15.
//  Copyright (c) 2015 king.wu. All rights reserved.
//

/**
 *  这个类是下拉 或 上拉 刷新 view 的基类
 */

#import <UIKit/UIKit.h>


#define OTPullDownRefreshViewHEIGHT (60)
#define OTPullUpRefreshViewHEIGHT   (80)


//下拉或上拉时要处理的动作句柄
typedef void(^OTPullActionHandler)(void);


@interface OTPullRefreshBaseView : UIView

@property (nonatomic, assign)UIEdgeInsets originalScrollViewInset;//原始的scrollView的inset
@property (nonatomic, weak)UIScrollView *scrollView; //parentView
@property (nonatomic, copy)OTPullActionHandler actionHandler; //属性动作句柄

/**
 *  自动开始刷新，一般用于第一次进入页面时的下拉更新
 */
- (void)autoStartRefresh;

/**
 *  停止刷新
 *
 *  @param isSuccess 表示数据刷新成功还是失败
 */
- (void)stopRefresh:(BOOL)isSuccess;

/**
 *  移除 对scrollView的 kvo 监听
 */
- (void)removeKVO;

/**
 *  加入 对scrollView的 kvo 监听
 */
- (void)addKVO;



/**
 *   刷新是否正在进行。
 *
 *  @return 返回 刷新是否正在进行的值
 */
- (BOOL)isPullRefreshExcuting;

@end

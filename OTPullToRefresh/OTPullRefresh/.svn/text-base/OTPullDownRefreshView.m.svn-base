//
//  OTPullDownRefreshView.m
//  OTPullToRefresh
//
//  Created by king.wu on 1/29/15.
//  Copyright (c) 2015 king.wu. All rights reserved.
//

#import "OTPullDownRefreshView.h"



#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)


@interface OTPullDownRefreshView ()

typedef NS_ENUM(NSUInteger, OTPullRefreshState)
{
    OTPullRefreshStateNormal = 0, //常态
    OTPullRefreshStateTriggered,  //触发状态， 显示“释放后立即刷新”
    OTPullRefreshStateLoading,    //正在加载状态
    OTPullRefreshStateFinshedSuccess, //刷新数据成功 状态
    OTPullRefreshStateFinshedFailed   //刷新数据失败 状态
};

@property (nonatomic, assign)OTPullRefreshState state;//刷新状态

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *arrowImageView;
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong)UIImageView *finishedIcon;


@end

@implementation OTPullDownRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = OTPullRefreshStateNormal;
        
        //self.backgroundColor = [UIColor redColor];
        
        }
    return self;
}

//init subViews
- (void)initSubViews
{
    //init titleLabel
    if(!self.titleLabel)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        self.titleLabel.text = @"下拉刷新";
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
    }
    
    //init arrowImageView
    if (!self.arrowImageView) {
        UIImage *image = [UIImage imageNamed:@"whiteArrow"];
        self.arrowImageView = [[UIImageView alloc]initWithImage:image];
        
        [self addSubview:self.arrowImageView];
    }
    
    //init indicatorView
    if (!self.indicatorView) {
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicatorView.hidden = YES;
        
        [self addSubview:self.indicatorView];
    }
}


- (void)layoutSubviews
{
    [self updateTitleLabelByState:self.state];
    [self updateIndicatorViewByState:self.state];
    [self updateArrowImageViewByState:self.state];

}

#pragma mark - refresh
/**
 *  自动开始刷新，一般用于第一次进入页面时的更新
 */
- (void)autoStartRefresh
{
    self.state = OTPullRefreshStateTriggered;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, - self.originalScrollViewInset.top - self.frame.size.height) animated:YES];
    
    self.state = OTPullRefreshStateLoading;
}

/**
 *  停止刷新
 *
 *  @param isSuccess 表示数据刷新成功还是失败
 */
- (void)stopRefresh:(BOOL)isSuccess;

{
    if (isSuccess) {
        self.state = OTPullRefreshStateFinshedSuccess;
    }
    else
    {
        self.state = OTPullRefreshStateFinshedFailed;
    }
}


- (BOOL)isPullRefreshExcuting
{
    return self.state == OTPullRefreshStateLoading;
}


#pragma mark - state
/**
 *  设置状态
 */
- (void)setState:(OTPullRefreshState)newState
{
    
    if(_state == newState)
    {
        return;
    }
    
    OTPullRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    switch (newState)
    {
        case OTPullRefreshStateNormal:
            break;
            
        case OTPullRefreshStateTriggered:
            break;
            
        case OTPullRefreshStateLoading:
        {
            [self setScrollViewContentInsetForLoading];
            
            //触发正在加载的 事件处理句柄
            if(previousState == OTPullRefreshStateTriggered && self.actionHandler)
            {
                self.actionHandler();
            }
        }
            break;
            
        case OTPullRefreshStateFinshedFailed:
        case OTPullRefreshStateFinshedSuccess:
        {
            [self setScrollViewContentInsetForFinishedWithDelay:0.3];
        }
            break;

    }
}

#pragma mark - scroll View

/**
 *  重置scrollView的 contentInset
 */
- (void)resetScrollViewContentInset
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalScrollViewInset.top;
    
    [self setScrollViewContentInset:currentInsets delay:0];
}


/**
 *  设置处于 正在加载 状态时的scrollView的cotentInset
 */
- (void)setScrollViewContentInsetForLoading
{
    CGFloat offset = MAX(-1 * self.scrollView.contentOffset.y, self.originalScrollViewInset.top);
    
    UIEdgeInsets currentInset = self.scrollView.contentInset;
    currentInset.top = MIN(offset, self.originalScrollViewInset.top + self.bounds.size.height);
    
    [self setScrollViewContentInset:currentInset delay:0];
}


/**
 *  设置处于 刷新完成 状态时的scrollView的cotentInset
 */
- (void)setScrollViewContentInsetForFinishedWithDelay:(float)delay
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalScrollViewInset.top;

    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         //这里需要去掉手势
                         self.scrollView.userInteractionEnabled = NO;
                         self.scrollView.panGestureRecognizer.enabled = NO;
                         
                         self.scrollView.contentInset = currentInsets;
                     }
                     completion:^(BOOL finished) {
                         
                         self.state = OTPullRefreshStateNormal;
                         
                         //打开手势
                        self.scrollView.panGestureRecognizer.enabled = YES;
                        self.scrollView.userInteractionEnabled = YES;
                     
                     }];
}


/**
 *  设置scrollView的 contentInset
 *
 *  @param contentInset
 *  @param delay 延迟
 */
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset delay:(NSTimeInterval)delay
{
    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self observeScrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        [self layoutSubviews];
        
        self.frame = CGRectMake(0, -1 * OTPullDownRefreshViewHEIGHT, self.bounds.size.width, OTPullDownRefreshViewHEIGHT);
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self layoutSubviews];
    }
}


/**
 *  kvo scrollView滚动时，offset的变化，对下拉刷新状态的影响
 *
 *  @param contentOffset scrollView的contentOffset
 */
- (void)observeScrollViewDidScroll:(CGPoint)contentOffset
{
  
    if(self.state != OTPullRefreshStateLoading && self.state != OTPullRefreshStateFinshedSuccess && self.state != OTPullRefreshStateFinshedFailed)
    {
        //触发状态变化的offset临界值
        CGFloat offsetThreshold  = self.frame.origin.y - self.originalScrollViewInset.top;
        
        
        if(!self.scrollView.isDragging && self.state == OTPullRefreshStateTriggered)
        {
            self.state = OTPullRefreshStateLoading;
        }
        else if(contentOffset.y < offsetThreshold && self.scrollView.isDragging && self.state == OTPullRefreshStateNormal)
        {
            self.state = OTPullRefreshStateTriggered;
        }
        else if(contentOffset.y >= offsetThreshold && self.scrollView.isDragging && self.state == OTPullRefreshStateTriggered)
        {
            self.state = OTPullRefreshStateNormal;
        }
    }
    else if (self.state == OTPullRefreshStateLoading)
    {
        CGFloat offsetY = MAX(-1 * self.scrollView.contentOffset.y, self.originalScrollViewInset.top);
        offsetY = MIN(offsetY, self.originalScrollViewInset.top + self.bounds.size.height);
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top = offsetY;
        self.scrollView.contentInset = contentInset;
    }
    else if ( (self.state == OTPullRefreshStateFinshedFailed || self.state == OTPullRefreshStateFinshedSuccess))
    {
    }
}


#pragma mark - viewChanged By state
//更新titleLabel
- (void)updateTitleLabelByState:(OTPullRefreshState)state
{
    switch (state)
    {
            
        case OTPullRefreshStateNormal:
            self.titleLabel.text = @"下拉刷新";
            break;
            
        case OTPullRefreshStateTriggered:
            self.titleLabel.text = @"释放立即刷新";
            break;
            
        case OTPullRefreshStateLoading:
            self.titleLabel.text = @"正在刷新...";
            break;
            
        case OTPullRefreshStateFinshedSuccess:
            self.titleLabel.text = @"刷新完成";
            break;
            
        case OTPullRefreshStateFinshedFailed:
            self.titleLabel.text = @"刷新失败";
            break;
    }
    
     self.titleLabel.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height) ;
}

//更新箭头
- (void)updateArrowImageViewByState:(OTPullRefreshState)state
{
    if (self.state == OTPullRefreshStateNormal) {
        
        self.arrowImageView.hidden = NO;
        
        [self rotateArrow:0 animated:NO isCCW:NO];
    }
    else if (self.state == OTPullRefreshStateTriggered)
    {
         self.arrowImageView.hidden = NO;
        
        [self rotateArrow:M_PI animated:YES isCCW:NO];
    }
    else
    {
        [self rotateArrow:0 animated:NO isCCW:NO];
        self.arrowImageView.hidden = YES;
    }
    
    
    CGRect frame = self.arrowImageView.frame;
    
    self.arrowImageView.frame = CGRectMake(self.titleLabel.frame.origin.x - 40, 0, frame.size.width, frame.size.height);
}
//更新 转圈
- (void)updateIndicatorViewByState :(OTPullRefreshState)state
{
    if (self.state == OTPullRefreshStateLoading) {
        [self.indicatorView startAnimating];
    }
    else
    {
        [self.indicatorView stopAnimating];
    }
    
    CGRect frame = self.indicatorView.frame;
    
    self.indicatorView.frame = CGRectMake(self.titleLabel.frame.origin.x - 40, self.bounds.size.height/2, frame.size.width, frame.size.height);
}

//箭头旋转
- (void)rotateArrow:(float)degrees animated:(BOOL)animated isCCW:(BOOL)isCCW
{
    int negative = isCCW ? 1 : -1;
    if (animated == YES)
    {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.arrowImageView.transform = CGAffineTransformMakeRotation(negative * degrees);
        } completion:NULL];
    }
    else
    {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(negative * degrees);
    }
    
}

@end

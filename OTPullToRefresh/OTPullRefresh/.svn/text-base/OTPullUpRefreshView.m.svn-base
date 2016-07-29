//
//  OTPullUpRefreshView.m
//  OTPullToRefresh
//
//  Created by king.wu on 2/2/15.
//  Copyright (c) 2015 king.wu. All rights reserved.
//

#import "OTPullUpRefreshView.h"

#define PULLUPADDOFFSET 10

@interface OTPullUpRefreshView ()

typedef NS_ENUM(NSUInteger, OTPullRefreshState)
{
    OTPullRefreshStateNormal = 0, //常态
    OTPullRefreshStateTriggered,  //触发状态， 显示“释放后立即刷新”
    OTPullRefreshStateLoading,    //正在加载状态
    OTPullRefreshStateFinshedSuccess, //刷新数据成功 状态
    OTPullRefreshStateFinshedFailed   //刷新数据失败 状态
};

@property (nonatomic, assign)OTPullRefreshState state;//刷新状态

@property (nonatomic, strong)UIView *containView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong)UIImageView *arrowImageView;

@end



@implementation OTPullUpRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = OTPullRefreshStateNormal;
        
        //一定不能设置backgroundColor，不然tableView最后一行插入动画，无效
    //    self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)initSubViews
{
    //initContainView
    if (!self.containView) {
        self.containView = [[UIView alloc]initWithFrame:self.bounds];
        self.containView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview: self.containView];
    }
    
    //init titleLabel
    if(!self.titleLabel)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        self.titleLabel.text = @"上拉加载更多...";
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.containView addSubview:self.titleLabel];
    }
    
    //init arrowImageView
    if (!self.arrowImageView) {
        UIImage *image = [UIImage imageNamed:@"whiteArrow"];
        self.arrowImageView = [[UIImageView alloc]initWithImage:image];
        
        [self rotateArrow:M_PI animated:NO isCCW:YES];
        [self.containView addSubview:self.arrowImageView];
    }

    
    //init indicatorView
    if (!self.indicatorView) {
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicatorView.hidden = YES;
        
        [self.containView addSubview:self.indicatorView];
    }

}


- (void)layoutSubviews
{
    [self updateIndicatorViewByState:self.state];
    [self updateTitleLabelByState:self.state];
    [self updateArrowImageViewByState:self.state];
}

#pragma mark - refresh
- (void)stopRefresh:(BOOL)isSuccess
{
    if (isSuccess)
    {
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
            if(previousState == OTPullRefreshStateTriggered  && self.actionHandler)
            {
                self.actionHandler();
            }
        }
            break;
            
        case OTPullRefreshStateFinshedSuccess:
            [self setScrollViewContentInsetForFinshedSuccess];
        case OTPullRefreshStateFinshedFailed:
            break;
            
        default:
            break;
    }
    
   
}


#pragma mark - scrollView

- (void)resetScrollViewContentInset
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalScrollViewInset.bottom;
    [self setScrollViewContentInset:currentInsets];
}


- (void)setScrollViewContentInsetForLoading
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalScrollViewInset.bottom + self.bounds.size.height;
    
    self.scrollView.contentInset = currentInsets;
  //  [self setScrollViewContentInset:currentInsets];
}


- (void)setScrollViewContentInsetForFinshedSuccess
{
    self.containView.hidden = YES;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        self.containView.hidden = NO;
        self.state = OTPullRefreshStateNormal;
    });
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}



#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self observeScrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        [self layoutSubviews];
        
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.bounds.size.width, OTPullUpRefreshViewHEIGHT);
    }
}

- (void)observeScrollViewDidScroll:(CGPoint)contentOffset
{
  
    if(self.state != OTPullRefreshStateLoading && self.state != OTPullRefreshStateFinshedSuccess)
    {
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        CGFloat offsetThreshold = self.bounds.size.height + scrollViewContentHeight - self.scrollView.bounds.size.height + PULLUPADDOFFSET;
        

        if(contentOffset.y > offsetThreshold && self.state == OTPullRefreshStateNormal && self.scrollView.isDragging)
        {
            self.state = OTPullRefreshStateTriggered;
        }
        if(!self.scrollView.isDragging && self.state == OTPullRefreshStateTriggered)
        {
            self.state = OTPullRefreshStateLoading;
        }
        else if(contentOffset.y < offsetThreshold  && self.state != OTPullRefreshStateNormal && self.scrollView.isDragging)
        {
            self.state = OTPullRefreshStateNormal;
        }
        else if(self.state == OTPullRefreshStateFinshedFailed && self.scrollView.isDragging)
        {
            self.state = OTPullRefreshStateNormal;
        }
    }
}

#pragma mark -  - viewChanged By state
//更新titleLabel
- (void)updateTitleLabelByState:(OTPullRefreshState)state
{
    switch (state)
    {
            
        case OTPullRefreshStateNormal:
            self.titleLabel.text = @"上拉加载更多...";
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
    
    self.titleLabel.frame = CGRectMake(self.bounds.size.width/2, 30, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height) ;
}

//更新箭头
- (void)updateArrowImageViewByState:(OTPullRefreshState)state
{
    if (self.state == OTPullRefreshStateNormal) {
        
        self.arrowImageView.hidden = NO;
        
        [self rotateArrow:M_PI animated:NO isCCW:NO];
    }
    else if (self.state == OTPullRefreshStateTriggered)
    {
        self.arrowImageView.hidden = NO;
        
        [self rotateArrow:2 * M_PI animated:YES isCCW:YES];
    }
    else
    {
        [self rotateArrow:M_PI animated:NO isCCW:NO];
        self.arrowImageView.hidden = YES;
    }
    
    
    CGRect frame = self.arrowImageView.frame;
    
    self.arrowImageView.frame = CGRectMake(self.titleLabel.frame.origin.x - 40, 5, frame.size.width, frame.size.height);
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
    
    self.indicatorView.frame = CGRectMake(self.titleLabel.frame.origin.x - 40, 30, frame.size.width, frame.size.height);
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
       // self.arrowImageView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    }
    
}

@end

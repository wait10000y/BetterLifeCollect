//
//  MJRefreshHeaderView.m
//  weibo
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#define kPullToRefresh    @"下拉开始刷新..."
#define kReleaseToRefresh @"释放立即刷新..."
#define kRefreshing       @"加载中..."

#define kTimeKey @"MJRefreshHeaderView"

#import "MJRefreshHeaderView.h"

@interface MJRefreshHeaderView()
@property (nonatomic, strong) NSDate *lastUpdateTime;
@end

@implementation MJRefreshHeaderView

+ (id)header
{
    return [[MJRefreshHeaderView alloc] init];
}

#pragma mark --- UIScrollView rewrite ScrollView ---
- (void)setScrollView:(UIScrollView *)scrollView
{
    [super setScrollView:scrollView];
    self.frame = CGRectMake(0, -kViewHeight, scrollView.frame.size.width, kViewHeight);
    _lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kTimeKey];
    [self updateTimeLabel];
}


- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateTime forKey:kTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateTimeLabel];
}

#pragma mark --- updateTime ---
- (void)updateTimeLabel
{
    if (!_lastUpdateTime) return;  
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    _lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", [formatter stringFromDate:_lastUpdateTime]];
}


- (void)setState:(RefreshState)state
{
    if (_state == state) return;
    [super setState:state];
    RefreshState oldState = _state;
	switch (_state = state) {
		case RefreshStatePulling:
        {
            _statusLabel.text = kReleaseToRefresh;
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = 0;
                _scrollView.contentInset = inset;
            }];
			break;
        }
		case RefreshStateNormal:
        {
			_statusLabel.text = kPullToRefresh;
            if (oldState == RefreshStateRefreshing) {
                // 保存刷新时间
                self.lastUpdateTime = [NSDate date];
#ifdef NeedAudio
                AudioServicesPlaySystemSound(_endRefreshId);
#endif     
            }
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = 0;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case RefreshStateRefreshing:
        {
            _statusLabel.text = kRefreshing;
            
            [UIView animateWithDuration:0.2 animations:^{
                // 1.顶部多出65的滚动范围
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = kViewHeight;
                _scrollView.contentInset = inset;
                // 2.设置滚动位置
                _scrollView.contentOffset = CGPointMake(0, -kViewHeight);
            }];
			break;
        }
	}
}

#pragma mark - 在父类中用得上
// 合理的Y值
- (CGFloat)validY
{
    return 0;
}

// view的类型
- (int)viewType
{
    return RefreshViewTypeHeader;
}
@end
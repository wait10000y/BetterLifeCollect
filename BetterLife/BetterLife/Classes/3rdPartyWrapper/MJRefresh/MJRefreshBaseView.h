//
//  MJRefreshBaseView.h
//  weibo
//  
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.


// 如果定义了NeedAudio这个宏，说明需要音频
// 依赖于AVFoundation.framework 和 AudioToolbox.framework
//#define NeedAudio

// view的高度
#define kViewHeight 65.0

//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
	RefreshStatePulling = 1,
	RefreshStateNormal = 2,
	RefreshStateRefreshing = 3
} RefreshState;

typedef enum {
    RefreshViewTypeHeader = -1,
    RefreshViewTypeFooter = 1
} RefreshViewType;

@class MJRefreshBaseView;

typedef void (^BeginRefreshingBlock)(MJRefreshBaseView *refreshView);

@protocol MJRefreshBaseViewDelegate <NSObject>
@optional
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
@end

@interface MJRefreshBaseView : UIView
{
    // scrollView
    __weak UIScrollView *_scrollView;
    __weak id<MJRefreshBaseViewDelegate> _delegate;
    BeginRefreshingBlock _beginRefreshingBlock;
    __weak UILabel *_lastUpdateTimeLabel;
	__weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
	__weak UIActivityIndicatorView *_activityView;
    RefreshState _state;
#ifdef NeedAudio
    SystemSoundID _normalId;
    SystemSoundID _pullId;
    SystemSoundID _refreshingId;
    SystemSoundID _endRefreshId;
#endif
}
@property (nonatomic, weak, readonly) UILabel *lastUpdateTimeLabel;
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, weak, readonly) UIImageView *arrowImage;
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, weak) id<MJRefreshBaseViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (nonatomic) UIColor *textColor;

- (id)initWithScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;
- (void)endRefreshing;
//- (void)free;

// rewrite for subClass
- (void)setState:(RefreshState)state;
@end
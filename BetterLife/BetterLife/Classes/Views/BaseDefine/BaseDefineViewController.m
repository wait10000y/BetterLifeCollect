//
//  BaseDefineViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"

//#import <QuartzCore/QuartzCore.h>
//#import <math.h>

//#define DeviceIOSVersion() return [UIDevice currentDevice].systemVersion.floatValue

#define startX -200;

#define KEY_WINDOW [[UIApplication sharedApplication]keyWindow]
#define ONE_CONTROLLER (self.viewControllers.count<=1)


@interface BaseDefineNavigationController ()
{
  CGPoint startTouch;
  UIImageView *lastScreenShotView;
  UIView *blackMask;
  UIPanGestureRecognizer *recognizer;
  CGFloat mFrameWidth;
}

@property (nonatomic,retain) NSMutableArray *screenShotsList;
@property (nonatomic, retain) UIView *backGroundView;
@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isOpened;

@end

@implementation BaseDefineNavigationController


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //屏蔽掉iOS7以后自带的滑动返回手势 否则有BUG
  if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.interactivePopGestureRecognizer.enabled = NO;
  }
  
  self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
  self.canDragBack = YES;
  firstTouch = YES;
  mFrameWidth = self.view.frame.size.width;
  for (int it=1; it<self.viewControllers.count-1; it++) {
    UIViewController *tempvc = self.viewControllers[it];
    [self.screenShotsList addObject:[self captureView:tempvc.view]];
  }
  NSLog(@"=========== viewControllers:%@ \n shotList:%@ ===========",self.viewControllers,self.screenShotsList);
}

//-(void)loadView
//{
//  [super loadView];
//  mFrameWidth = self.view.frame.size.width;
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  BOOL hasMethod = [self.dragBackDelegate respondsToSelector:@selector(baseNavigationShouldPushViewController:)];
  BOOL shouldPush = (!hasMethod || (hasMethod && [self.dragBackDelegate baseNavigationShouldPushViewController:viewController]));
  if (shouldPush) {
    [self.screenShotsList addObject:[self captureView:self.view]];
    NSLog(@"=========== viewControllers:%@ \n shotList:%@ ===========",self.viewControllers,self.screenShotsList);
    [super pushViewController:viewController animated:animated];
  }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
  if ([self.dragBackDelegate respondsToSelector:@selector(baseNavigationWillPopViewController)]) {
    [self.dragBackDelegate baseNavigationWillPopViewController];
  }
  [self.screenShotsList removeLastObject];
  NSLog(@"=========== viewControllers:%@ \n shotList:%@ ===========",self.viewControllers,self.screenShotsList);
  return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if ([self.dragBackDelegate respondsToSelector:@selector(baseNavigationWillPopToViewController:)]) {
    [self.dragBackDelegate baseNavigationWillPopToViewController:viewController];
  }
  NSInteger index = [self.viewControllers indexOfObject:viewController];
  if (index == NSNotFound) {
    return nil;
  }
  [self.screenShotsList removeObjectsInRange:NSMakeRange(index, self.viewControllers.count-index-1)];
  NSLog(@"=========== viewControllers:%@ \n shotList:%@ ===========",self.viewControllers,self.screenShotsList);
  return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
  if ([self.dragBackDelegate respondsToSelector:@selector(baseNavigationWillPopToRootViewController)]) {
    [self.dragBackDelegate baseNavigationWillPopToRootViewController];
  }
  [self.screenShotsList removeAllObjects];
  NSLog(@"=========== viewControllers:%@ \n shotList:%@ ===========",self.viewControllers,self.screenShotsList);
  return [super popToRootViewControllerAnimated:animated];
}

-(void)setCanDragBack:(BOOL)theFlag
{
  _canDragBack = theFlag;
  if (theFlag) {
    if (!recognizer) {
      recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
      [recognizer delaysTouchesBegan];
    }
    [self.view addGestureRecognizer:recognizer];
  }else{
    if (recognizer) {
      [self.view removeGestureRecognizer:recognizer];
      //      recognizer = nil;
    }
  }
}

#pragma mark - Utility Methods -

- (UIImage *)captureView:(UIView*)theView
{
  if ([theView isKindOfClass:[UIView class]]) {
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, self.view.opaque, 0.0);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
  }
  return [UIImage new];
}

//- (void)moveViewWithX:(float)x
//{
//  float balpha = x < 0 ? -x : x;
//  CATransform3D transform = CATransform3DIdentity;
//  transform = CATransform3DRotate(transform,(M_PI/180*(x/kDeviceWidth)*50), 0, 0, 1);
//  [self.view.layer setTransform:transform];
//  float alpha = 0.4 - (balpha/800);
//  blackMask.alpha = alpha;
//
//}


- (void)moveViewWithX:(float)x
{
  x = x>mFrameWidth?mFrameWidth:x;
  x = x<0?0:x;
  
  CGRect frame = self.view.frame;
  frame.origin.x = x;
  self.view.frame = frame;
  float alpha = 0.8 - (x/400);
  
  //  float scale = (x/6400)+0.95;
  //  CGAffineTransform transf = CGAffineTransformMakeScale(scale, scale);
  
  float offsetX = -40*(1-x/mFrameWidth);
  CGAffineTransform transf = CGAffineTransformMakeTranslation(offsetX, 0);
  
  lastScreenShotView.transform = transf;
  blackMask.alpha = alpha;
}


-(BOOL)isBlurryImg:(CGFloat)tmp
{
  return YES;
}

#pragma mark - UIPanGestureRecongnizer
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
  if(!self.canDragBack) return;
  
  // we get the touch position by the window's coordinate
  CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
  
  if (ONE_CONTROLLER) return;
  
  // begin paning, show the backGroundView(last screenshot),if not exist, create it.
  if (recoginzer.state == UIGestureRecognizerStateBegan) {
    //    NSLog(@"--- move begin ---");
    startTouch = touchPoint;
    
  }else if(recognizer.state == UIGestureRecognizerStateChanged){
    if (startTouch.x <40 && touchPoint.x - startTouch.x > 16)
    {
      if (ONE_CONTROLLER && _isMoving) {
        self.backGroundView.hidden = YES;
        _isMoving = NO;
        //            UIImage *image = [self captureView:self.view];
        //            lastScreenShotView = [[UIImageView alloc]initWithImage:image];
        return;
      }
      
      if(!_isMoving){
        if (!self.backGroundView)
        {
          CGRect frame = self.view.frame;
          self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
          blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
          blackMask.backgroundColor = [UIColor blackColor];
          [self.backGroundView addSubview:blackMask];
        }
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backGroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
        [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
        self.backGroundView.hidden = NO;
        _isMoving = YES;
      }
      
    }
    
  }else if (recoginzer.state == UIGestureRecognizerStateEnded){
    //    NSLog(@"--- move end ---");
    BOOL shouldPop = (startTouch.x <40 && touchPoint.x - startTouch.x > 80);
    if (shouldPop) {
      BOOL hasMethod = [self.dragBackDelegate respondsToSelector:@selector(baseNavigationShouldPopViewController)];
      shouldPop = (!hasMethod || (hasMethod && [self.dragBackDelegate baseNavigationShouldPopViewController]));
    }
    
    if (shouldPop)
    {
      [UIView animateWithDuration:dragBackAnimateDurain animations:^{
        [self moveViewWithX:mFrameWidth];
      } completion:^(BOOL finished) {
        CGRect frame = self.view.frame;
        frame.origin.x = 200;
        if (!ONE_CONTROLLER) {
          [self popViewControllerAnimated:NO];
          frame.origin.x = 0;
        }
        self.view.frame = frame;
        _isMoving = NO;
        //        NSLog(@"--- move complete ---");
      }];
    }
    else
    {
      [UIView animateWithDuration:dragBackAnimateDurain animations:^{
        [self moveViewWithX:0];
      } completion:^(BOOL finished) {
        _isMoving = NO;
        self.backGroundView.hidden = YES;
        //        NSLog(@"--- move complete ---");
      }];
    }
    return;
    
    // cancal panning, alway move to left side automatically
  }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
    //    NSLog(@"--- move cancel ---");
    [UIView animateWithDuration:dragBackAnimateDurain animations:^{
      [self moveViewWithX:0];
    } completion:^(BOOL finished) {
      _isMoving = NO;
      self.backGroundView.hidden = YES;
      //      NSLog(@"--- move complete ---");
    }];
    return;
  }
  // it keeps move with touch
  if (_isMoving) {
    [self moveViewWithX:touchPoint.x - startTouch.x];
  }
}

  // 支持 旋转 功能
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return !self.disableAutorotate;
}
- (BOOL)shouldAutorotate
{
  return self.disableAutorotate?NO:[super shouldAutorotate];
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//
//}

@end

@interface BaseDefineViewController ()

@end

@implementation BaseDefineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  NSString *detalNibName = deviceIsPad?@"_iPad":@"_iPhone";
  self = [super initWithNibName:(nibNameOrNil?[nibNameOrNil stringByAppendingString:detalNibName]:nil) bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    // Do any additional setup after loading the view.
  if ([self isLastIOS7]) {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
      self.edgesForExtendedLayout = UIRectEdgeNone;
    }
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(id)loadNibViewController:(NSString*)theNibName
{
  return [[[self class] alloc] initWithNibName:theNibName?:NSStringFromClass([self class]) bundle:nil];
}

+(id)loadNibView:(NSString*)theNibName
{
  NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:theNibName owner:nil options:nil];
  if (viewArr.count>0) {
    return [viewArr firstObject];
  }
  return nil;
}

  // ============= base utils ==============
-(UIViewAutoresizing)getViewAllResizingMask
{
  return UIViewAutoresizingFlexibleLeftMargin|
  UIViewAutoresizingFlexibleWidth|
  UIViewAutoresizingFlexibleRightMargin|
  UIViewAutoresizingFlexibleTopMargin|
  UIViewAutoresizingFlexibleHeight|
  UIViewAutoresizingFlexibleBottomMargin;
}

-(UIView*) errorView {
  UILabel *actiView = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
  actiView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
  actiView.autoresizingMask = [self getViewAllResizingMask];
  actiView.text = @"发生错误";
  return actiView;
}



-(UIView*) loadingView {
  UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  actiView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
  actiView.frame = [UIScreen mainScreen].bounds;
  actiView.autoresizingMask = [self getViewAllResizingMask];
  actiView.hidesWhenStopped = YES;
  [actiView startAnimating];
  return actiView;
}

-(void) showLoadingAnimated:(BOOL) animated {
  UIView *loadingView = [self loadingView];
  loadingView.alpha = 0.0f;
  [self.view addSubview:loadingView];
  [self.view bringSubviewToFront:loadingView];
  double duration = animated ? 0.4f:0.0f;
  [UIView animateWithDuration:duration animations:^{
    loadingView.alpha = 1.0f;
  }];
}

-(void) hideLoadingViewAnimated:(BOOL) animated {
  UIView *loadingView = [self loadingView];
  double duration = animated ? 0.4f:0.0f;
  [UIView animateWithDuration:duration animations:^{
    loadingView.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [loadingView removeFromSuperview];
  }];
  
}

-(void) showErrorViewAnimated:(BOOL) animated {
  UIView *errorView = [self errorView];
  errorView.alpha = 0.0f;
  [self.view addSubview:errorView];
  [self.view bringSubviewToFront:errorView];
  double duration = animated ? 0.4f:0.0f;
  [UIView animateWithDuration:duration animations:^{
    errorView.alpha = 1.0f;
  }];
}

-(void) hideErrorViewAnimated:(BOOL) animated {
  UIView *errorView = [self errorView];
  double duration = animated ? 0.4f:0.0f;
  [UIView animateWithDuration:duration animations:^{
    errorView.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [errorView removeFromSuperview];
  }];
}

-(BOOL)isLastIOS7
{
  return ([UIDevice currentDevice].systemVersion.floatValue >= 7.0);
}

-(BOOL)isLastIOS6
{
  return ([UIDevice currentDevice].systemVersion.floatValue >= 6.0);
}

-(float)getIOSVersion
{
  return [UIDevice currentDevice].systemVersion.floatValue;
}

-(void)setDisableAutorotate:(BOOL)tDisableAutorotate
{
  _disableAutorotate = tDisableAutorotate;
  if ([self.navigationController isKindOfClass:[BaseDefineNavigationController class]]) {
    ((BaseDefineNavigationController*)self.navigationController).disableAutorotate = _disableAutorotate;
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return !self.disableAutorotate;
}

- (BOOL)shouldAutorotate
{
  return self.disableAutorotate?NO:[super shouldAutorotate];
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//}

- (NSDate *)getDateWithDateString:(NSString *)strDate formatString:(NSString*)strFormat withTimeZone:(NSTimeZone*)timeZone{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  if (!timezone) {
    timeZone =  [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
  }
  [formatter setTimeZone:timeZone];
  
  if (!strFormat) {
    strFormat = @"yyyy-MM-dd HH:mm:ss";
  }
  [formatter setDateFormat : strFormat];

  NSDate *dateTime = [formatter dateFromString:strDate];
  return dateTime;
}

-(NSString*)getDateStringWithDate:(NSDate*)theDate formatString:(NSString*)strFormat withTimeZone:(NSTimeZone*)timeZone
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  if (!timezone) {
    timeZone =  [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
  }
  [formatter setTimeZone:timeZone];
  if (!strFormat) {
    strFormat = @"yyyy-MM-dd HH:mm:ss";
  }
  [formatter setDateFormat : strFormat];
  
  return [formatter stringFromDate:theDate];
}

@end

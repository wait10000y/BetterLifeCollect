//
//  BaseDefineViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <math.h>

//#define DeviceIOSVersion() return [UIDevice currentDevice].systemVersion.floatValue

#define startX -200;
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

@interface BaseDefineNavigationController ()
{
  CGPoint startTouch;
  UIImageView *lastScreenShotView;
  UIView *blackMask;
  UIPanGestureRecognizer *recognizer;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

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
  self.specialPop = YES;
  firstTouch = YES;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  [self.screenShotsList addObject:[self capture]];
  
  
  [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
  [self.screenShotsList removeLastObject];
  return [super popViewControllerAnimated:animated];
    if (self.specialPop) {
        [self pop];
        return [super popViewControllerAnimated:NO];
    }else{
        return [super popViewControllerAnimated:animated];
    }
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

- (UIImage *)capture
{
  UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
  [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  
  
  return img;
}

- (void)moveViewWithX:(float)x
{
  float balpha = x < 0 ? -x : x;
  CATransform3D transform = CATransform3DIdentity;
  transform = CATransform3DRotate(transform,(M_PI/180*(x/kDeviceWidth)*50), 0, 0, 1);
  [self.view.layer setTransform:transform];
  float alpha = 0.4 - (balpha/800);
  blackMask.alpha = alpha;
  
}



-(BOOL)isBlurryImg:(CGFloat)tmp
{
  return YES;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
  if (self.viewControllers.count <= 1 || !self.canDragBack) return;
  
  CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
  
  if (recoginzer.state == UIGestureRecognizerStateBegan) {
    
    if (firstTouch) {
      CALayer *layer = [self.view layer];
      CGPoint oldAnchorPoint = layer.anchorPoint;
      [layer setAnchorPoint:CGPointMake(0.5, 1.0)];
      [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - oldAnchorPoint.x), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - oldAnchorPoint.y))];
      firstTouch = NO;
    }
    
    
    _isMoving = YES;
    startTouch = touchPoint;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    if (!self.backgroundView)
    {
      
      
      self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
      [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
      
      blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
      blackMask.backgroundColor = [UIColor blackColor];
      [self.backgroundView addSubview:blackMask];
    }
    
    self.backgroundView.hidden = NO;
    
    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
    
    
    UIImage *lastScreenShot = [self.screenShotsList lastObject];
    
    lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
    
    
    
      //[lastScreenShotView setBackgroundColor:[UIColor purpleColor]];
    
    startBackViewX = startX;
    [lastScreenShotView setFrame:frame];
      //[self.backgroundView addSubview:lastScreenShotView];
    
    [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
    
  }else if (recoginzer.state == UIGestureRecognizerStateEnded){
    
    if (touchPoint.x - startTouch.x > 150)
    {
      [self pop];
    }
    else
    {
      [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:0];
      } completion:^(BOOL finished) {
        _isMoving = NO;
        self.backgroundView.hidden = YES;
      }];
      
    }
    return;
    
  }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
    
    [UIView animateWithDuration:0.3 animations:^{
      [self moveViewWithX:0];
    } completion:^(BOOL finished) {
      _isMoving = NO;
      self.backgroundView.hidden = YES;
    }];
    
    return;
  }
  
  if (_isMoving) {
    [self moveViewWithX:touchPoint.x - startTouch.x];
  }
}

- (void)pop
{
  [UIView animateWithDuration:0.4 animations:^{
    [self moveViewWithX:kDeviceWidth*2];
    CGRect frame = self.view.bounds;
    frame.origin.x = kDeviceWidth;
    frame.origin.y += 250;
    [self.view setFrame:frame];
  } completion:^(BOOL finished){
    [self popViewControllerAnimated:NO];
    CATransform3D transform = CATransform3DIdentity;
    [self.view.layer setTransform:transform];
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = 0;
    self.view.frame = frame;
    _isMoving = NO;
  }];
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

@end

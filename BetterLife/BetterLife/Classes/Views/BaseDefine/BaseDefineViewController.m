//
//  BaseDefineViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"

//#define DeviceIOSVersion() return [UIDevice currentDevice].systemVersion.floatValue

@implementation BaseDefineNavigationController


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

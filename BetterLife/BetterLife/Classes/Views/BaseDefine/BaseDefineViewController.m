//
//  BaseDefineViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"

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





  // ============= base utils ==============

-(UIView*) errorView {
  
  return nil;
}

-(UIView*) loadingView {
  
  return nil;
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


@end

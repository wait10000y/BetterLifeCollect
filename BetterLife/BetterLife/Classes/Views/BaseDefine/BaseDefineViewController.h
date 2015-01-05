//
//  BaseDefineViewController.h
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define deviceIsPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define deviceIsPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface BaseDefineViewController : UIViewController











-(UIView*) errorView;
-(UIView*) loadingView;

-(void) showLoadingAnimated:(BOOL) animated;
-(void) hideLoadingViewAnimated:(BOOL) animated;
-(void) showErrorViewAnimated:(BOOL) animated;
-(void) hideErrorViewAnimated:(BOOL) animated;

-(float)getIOSVersion;

@end

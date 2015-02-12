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

@interface BaseDefineNavigationController : UINavigationController

@property (nonatomic) BOOL disableAutorotate;

@end

@interface BaseDefineViewController : UIViewController

@property (nonatomic) BOOL disableAutorotate;






+(id)loadNibViewController:(NSString*)theNibName;
+(id)loadNibView:(NSString*)theNibName;


-(UIView*) errorView;
-(UIView*) loadingView;

-(void) showLoadingAnimated:(BOOL) animated;
-(void) hideLoadingViewAnimated:(BOOL) animated;
-(void) showErrorViewAnimated:(BOOL) animated;
-(void) hideErrorViewAnimated:(BOOL) animated;

-(BOOL)isLastIOS7;
-(BOOL)isLastIOS6;
-(float)getIOSVersion;

@end

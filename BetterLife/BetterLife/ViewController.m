//
//  ViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-21.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
//  label.text = @"test label text";
//  [self.view addSubview:label];
//  label.backgroundColor = [UIColor lightGrayColor];
//  label.center = self.view.center;
////  label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
////  +UIViewAutoresizingFlexibleTopMargin
////  +UIViewAutoresizingFlexibleRightMargin
////  +UIViewAutoresizingFlexibleLeftMargin;
//  
//  label.autoresizingMask =UIViewAutoresizingFlexibleTopMargin+UIViewAutoresizingFlexibleBottomMargin;
  
  /*
   typedef NS_OPTIONS(NSUInteger, UIViewAutoresizing) {
   UIViewAutoresizingNone                 = 0,
   UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
   UIViewAutoresizingFlexibleWidth        = 1 << 1,
   UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
   UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
   UIViewAutoresizingFlexibleHeight       = 1 << 4,
   UIViewAutoresizingFlexibleBottomMargin = 1 << 5
   };
   */
  
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

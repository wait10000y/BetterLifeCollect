//
//  TestImageViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14/12/16.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "TestImageViewController.h"

@interface TestImageViewController ()

- (IBAction)actionPlayImages:(UIButton *)sender;

@end

@implementation TestImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self setPlayImages];
}

-(void)setPlayImages
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    imageView.animationImages = @[
                                  [UIImage imageNamed:@"test1"],
                                  [UIImage imageNamed:@"test2"],
                                  [UIImage imageNamed:@"test3"],
                                  [UIImage imageNamed:@"test4"]
                                  ];
    imageView.animationDuration = 2.0f;
  }
}

-(void)startPlayImages
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    [imageView startAnimating];
  }
}

-(void)stopPlayImages
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    [imageView stopAnimating];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionPlayImages:(UIButton *)sender {
  sender.enabled = NO;
  if (sender.tag == 102) {
    ((UIButton*)[self.view viewWithTag:103]).enabled = YES;
    [self startPlayImages];
    
  }else if (sender.tag == 103){
    [self stopPlayImages];
    ((UIButton*)[self.view viewWithTag:102]).enabled = YES;
  }
  
}
@end

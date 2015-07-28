//
//  TestImageViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14/12/16.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "TestImageViewController.h"

#import "UIImage+animatedGIF.h"
#import "UIImage+Color.h"

@interface TestImageViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)actionPlayImages:(UIButton *)sender;

@end

@implementation TestImageViewController
{
  int type; // 0:normal,1:gif,2:colors
  NSTimer *showTimer;
  
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    type = 0;
    [self setPlayImages];
  
  [self.segment addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
  
}

-(void)segmentedControlValueChanged:(UISegmentedControl*)theSender
{
  [self actionPlayImages:(UIButton*)[self.view viewWithTag:103]];
  type = theSender.selectedSegmentIndex;
  [self setPlayImages];
}

-(void)imageViewTurnColorImage:(id)theSender
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
  [UIView animateWithDuration:1.0f animations:^{
    imageView.image = [UIImage imageWithColor:[self randomColor]];
  }];
  }
}

-(void)setPlayImages
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    switch (type) {
      case 0:
      {
        NSArray *imageArr = @[
                              [UIImage imageWithColor:[self randomColor]],
                              [UIImage imageWithColor:[self randomColor]],
                              [UIImage imageWithColor:[self randomColor]],
                              [UIImage imageWithColor:[self randomColor]],
                              [UIImage imageWithColor:[self randomColor]]
                              ];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.animationImages = imageArr;
        imageView.animationDuration = 1.0f;
        
//        UIImage *image = [UIImage animatedImageNamed:@"test3" duration:0.2f];

      } break;
      case 1:
      {
        imageView.contentMode = UIViewContentModeCenter;
//        NSArray *imageArr = @[];
//        UIImage *image = [UIImage animatedImageWithImages:imageArr duration:1.0f];
//        imageView.image = image;
        
        UIImage *image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test3" ofType:@"gif"]]];
        imageView.image = image;
        
      } break;
      case 2:
      {
        imageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *image = [UIImage imageWithColor:[self randomColor]];
        imageView.image = image;
      } break;
        
      default:
        break;
    }
    
  }
}

-(void)startPlayImages
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    switch (type) {
      case 0:
      {
        
      } break;
      case 1:
      {
        
      } break;
      case 2:
      {
        if (showTimer) {
          [showTimer invalidate];
        }
        showTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(imageViewTurnColorImage:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:showTimer forMode:NSRunLoopCommonModes];
        [showTimer fire];
      } break;
        
      default:
        break;
    }
    [imageView startAnimating];
  }
}

-(void)stopPlayImages
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    switch (type) {
      case 0:
      {
        
      } break;
      case 1:
      {
        
      } break;
      case 2:
      {
        if (showTimer) {
          [showTimer invalidate];
          showTimer = nil;
        }
      } break;
        
      default:
        break;
    }
    [imageView stopAnimating];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

// ---------------------------

-(UIColor *)randomColor
{
  return [[UIColor alloc] initWithRed:random()%255/255.0f
                                green:random()%255/255.0f
                                 blue:random()%255/255.0f
                                alpha:random()%255/255.0f];
}







@end

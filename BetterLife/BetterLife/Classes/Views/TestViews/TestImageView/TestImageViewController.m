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

@property (nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) NSTimer *showTimer;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)actionPlayImages:(UIButton *)sender;

@end

@implementation TestImageViewController
{
  NSInteger type; // 0:normal,1:gif,2:colors
  
}
@synthesize showTimer;


- (void)viewDidLoad
{
    [super viewDidLoad];
    type = 0;
    [self setPlayImages];
  
  [self.segment addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
  
}

-(void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [self stopPlayImages];
}

-(void)segmentedControlValueChanged:(UISegmentedControl*)theSender
{
  [self actionPlayImages:(UIButton*)[self.view viewWithTag:103]];
  type = theSender.selectedSegmentIndex;
  [self setPlayImages];
//  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//    [self setPlayImages];
//  }];
}

-(void)imageViewTurnColorImage:(id)theSender
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    
  [UIView animateWithDuration:4.0f animations:^{
//    imageView.image = [UIImage imageWithColor:[self randomColor]];
    imageView.backgroundColor = [self randomColor];
  }];
  }
}

-(void)setPlayImages
{
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  if (imageView) {
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = nil;
    imageView.animationImages = nil;
    if (self.gradientLayer && [imageView.layer.sublayers containsObject:self.gradientLayer]) {
      [self.gradientLayer removeFromSuperlayer];
    }
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
//        UIImage *image = [UIImage imageWithColor:[self randomColor]];
//        imageView.image = image;
        imageView.backgroundColor = [self randomColor];
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
        imageView.image = nil;
        if (showTimer) {
          [showTimer invalidate];
        }
//        showTimer = [NSTimer timerWithTimeInterval:4.0f target:self selector:@selector(imageViewTurnColorImage:) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:showTimer forMode:NSRunLoopCommonModes];
//        [showTimer fire];
        [self startRandomImgColor];
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
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = nil;
    imageView.animationImages = nil;
    if (self.gradientLayer && [imageView.layer.sublayers containsObject:self.gradientLayer]) {
      [self.gradientLayer removeFromSuperlayer];
    }
    switch (type) {
      case 0:
      {
        
      } break;
      case 1:
      {
        
      } break;
      case 2:
      {
//        if (showTimer) {
//          [showTimer invalidate];
//        }
//          showTimer = nil;
        [self stopRandomImgColor];
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
//  return [[UIColor alloc] initWithRed:random()%255/255.0f
//                                green:random()%255/255.0f
//                                 blue:random()%255/255.0f
//                                alpha:random()%255/255.0f];
  
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}



-(void)startRandomImgColor
{
//  //初始化imageView
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
  
  //初始化渐变层
  self.gradientLayer = [CAGradientLayer layer];
  self.gradientLayer.frame = imageView.bounds;
  [imageView.layer addSublayer:self.gradientLayer];
  
  //设置渐变颜色方向
  self.gradientLayer.startPoint = CGPointMake(0, 0);
  self.gradientLayer.endPoint = CGPointMake(0, 1);
  
  //设定颜色组
  self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                (__bridge id)[UIColor purpleColor].CGColor];
  
  //设定颜色分割点
  self.gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
  
  //定时器
  showTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                target:self
                                              selector:@selector(TimerEvent)
                                              userInfo:nil
                                               repeats:YES];
}

-(void)stopRandomImgColor
{
  if ([showTimer isValid]) {
    [showTimer invalidate];
  }
  showTimer = nil;
}

- (void)TimerEvent
{
  //定时改变颜色
  self.gradientLayer.colors = @[(__bridge id)[self randomColor].CGColor,
                                (__bridge id)[self randomColor].CGColor];
  
  //定时改变分割点
  self.gradientLayer.locations = @[@([self randomFloat]), @([self randomFloat])];
  
  //设置渐变颜色方向
  self.gradientLayer.startPoint = CGPointMake([self randomFloat], [self randomFloat]);
  self.gradientLayer.endPoint = CGPointMake([self randomFloat], [self randomFloat]);
  
}

-(float)randomFloat
{
  return (arc4random() % 100 / 100.0f);
}

@end


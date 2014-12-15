//
//  TestSnowFallViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-27.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "TestSnowFallViewController.h"

@interface TestSnowFallViewController ()

@end

@implementation TestSnowFallViewController
{
  UIImage *mSnowItem;
  NSTimer *mTimer;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
  [super viewDidLoad];
    //初始化图片
  mSnowItem = [UIImage imageNamed:@"snow_flake.png"];
    //启动定时器，实现飘雪效果
}

-(void)viewDidAppear:(BOOL)animated
{
  mTimer = [NSTimer scheduledTimerWithTimeInterval:(0.2f) target:self selector:@selector(showNextSnowView) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
  if ([mTimer isValid]) {
    [mTimer invalidate];
  }
  mTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showNextSnowView{
  UIImageView *view = [[UIImageView alloc] initWithImage:mSnowItem];//声明一个UIImageView对象，用来添加图片
  view.alpha = 0.5;//设置该view的alpha为0.5，半透明的
  int x = round(random()%320);//随机得到该图片的x坐标
  int y = round(random()%320);//这个是该图片移动的最后坐标x轴的
  int s = round(random()%15)+10;//这个是定义雪花图片的大小
  int sp = 1/round(random()%100)+1;//这个是速度
  view.frame = CGRectMake(x, 0, s, s);//雪花开始的大小和位置
  [self.view addSubview:view];//添加该view
  [UIView beginAnimations:nil context:(__bridge void *)(view)];//开始动画
  [UIView setAnimationDuration:10*sp];//设定速度
  view.frame = CGRectMake(y, self.view.frame.size.height+20, s, s);//设定该雪花最后的消失坐标
  [UIView setAnimationDelegate:self];
  [UIView commitAnimations];
}

@end

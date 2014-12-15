//
//  Test2048ViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-12-10.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "Test2048ViewController.h"

@interface Test2048ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnUndo;

@property (weak, nonatomic) IBOutlet UIView *viewBody;

- (IBAction)actionBtnPress:(UIButton *)sender;
- (IBAction)actionSwipe:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeItem;

@end

@implementation Test2048ViewController

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
  self.view.backgroundColor = [UIColor lightGrayColor];
//  self.swipeItem.direction = UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown ;
  
  
  
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)actionBtnPress:(UIButton *)sender {
  NSLog(@"------------ actionBtnPress ---------------");
}

/*
 UISwipeGestureRecognizerDirectionRight = 1 << 0,
 UISwipeGestureRecognizerDirectionLeft  = 1 << 1,
 UISwipeGestureRecognizerDirectionUp    = 1 << 2,
 UISwipeGestureRecognizerDirectionDown  = 1 << 3
 */
- (IBAction)actionSwipe:(UISwipeGestureRecognizer *)sender {

  NSString *strDirection;
  /*
   if (sender.direction & UISwipeGestureRecognizerDirectionRight) {
   strDirection = @"Right";
   }else if (sender.direction & UISwipeGestureRecognizerDirectionLeft){
   strDirection = @"Left";
   }else if (sender.direction & UISwipeGestureRecognizerDirectionUp){
   strDirection = @"Up";
   }else if (sender.direction & UISwipeGestureRecognizerDirectionDown){
   strDirection = @"Down";
   }else{
   strDirection = @"Unknow";
   }
   */
  
  switch (sender.direction) {
    case UISwipeGestureRecognizerDirectionRight:
    {
      strDirection = @"Right";
    }break;
    case UISwipeGestureRecognizerDirectionLeft:
    {
      strDirection = @"Left";
    }break;
    case UISwipeGestureRecognizerDirectionUp:
    {
      strDirection = @"Up";
    }break;
    case UISwipeGestureRecognizerDirectionDown:
    {
      strDirection = @"Down";
    }break;
      
    default:
      strDirection = @"Unknow";
      break;
  }
  [self.btnStart setTitle:strDirection forState:UIControlStateNormal];
  NSLog(@"------------ actionSwipe:%@ ---------------",strDirection);
}














@end



//
//  TestTextFieldViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-24.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "TestTextFieldViewController.h"



@interface TestTextFieldViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldRound;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLine;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBezel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRound2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNoBorder;

- (IBAction)actionShake:(UIButton *)sender;

@end

@implementation TestTextFieldViewController
{
  NSInteger mIndex;
}

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
  mIndex = 1;
  
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionShake:(UIButton *)sender {
  if (mIndex > 5) {mIndex = 1;}
  UITextField *tempTF = [self.view viewWithTag:mIndex];
  if (tempTF) {
    [tempTF shake];
  }
  mIndex ++;
}
@end

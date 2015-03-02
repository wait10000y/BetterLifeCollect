//
//  TestStringViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14/12/15.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "TestStringViewController.h"
#import "BaseDefineObject.h"

@interface TestStringViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TestStringViewController
{
  NSString *mTestStr;
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
  self.title = @"测试结果";
    [super viewDidLoad];
  mTestStr = @"test str value";
  [self testPointTrans];
  
  
  [self othersTest];
  [self testObjectPropertyDefaultValue];
  [self testObjectPropertyDefaultValue];
  [self testObjectPropertyDefaultValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testPointTrans
{
  int sPIndex = &mTestStr;
  NSLog(@"--- sPIndex: %x ,%d ---",sPIndex,sPIndex);
  NSLog(@"---- str point:%x ,%d ----",&mTestStr);
  
  

  
//  NSString *tempStr = (NSString*)sPIndex;
  
  
  
}

-(void)appendShowString:(NSString*)theStr
{
  self.textView.text = [self.textView.text?:@"" stringByAppendingString:theStr];
}

//-(void)appendShowStringByFormat:(NSString *)theFormat, ...
//{
//  self.textView.text = [self.textView.text?:@"" stringByAppendingFormat:theFormat];
//}

-(void)showString:(NSString*)theStr
{
  self.textView.text = theStr;
}

-(void)clearShowString
{
  self.textView.text = nil;
}



-(void)testObjectPropertyDefaultValue
{
  
    //  @property (nonatomic) int iValue;
    //  @property (nonatomic) double dValue;
    //  @property (nonatomic) char cValue;
    //  @property (nonatomic) struct sValue;
  
  BaseDefineObject *bdo = [BaseDefineObject new];
  NSString *tempStr = [NSString stringWithFormat:@"-===object default value:\n int:%d ,double:%f ,char:%c ===-",bdo.iValue,bdo.dValue,bdo.cValue];
  [self appendShowString:tempStr];
}

-(void)othersTest
{
//  [self appendShowStringByFormat:@"---- 7&8=%d ----",7&8];

  
  NSLog(@"---- 7&8=%d ----",7&8);
  NSLog(@"---- 8&0=%d ----",8&0);
  NSLog(@"---- 7&14=%d ----",7&14);
  NSLog(@"---- 3|0=%d ----",3|0);
  NSLog(@"---- 0|0=%d ----",0|0);
  
  
  NSLog(@"---- 7&4=%d ----",7&4);
  NSLog(@"---- 3&2=%d ----",3&2);
  
  NSLog(@"---- 3&1=%d ----",3&1);
  NSLog(@"---- 3|4=%d ----",3|4);
  NSLog(@"---- 1|2=%d ----",1|2);
  
  UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
  tempView.backgroundColor = [UIColor grayColor];
  
  [self.view addSubview:tempView];
  
  NSLog(@"------ tempView.hidden:%d --------",tempView.hidden);
  
  tempView.hidden = YES;
  
  NSLog(@"------ tempView.hidden:%d --------",tempView.hidden);
    //  tempView.hidden = NO;
    //
    //  NSLog(@"------ tempView.hidden:%d --------",tempView.hidden);
  
  
  
}

@end

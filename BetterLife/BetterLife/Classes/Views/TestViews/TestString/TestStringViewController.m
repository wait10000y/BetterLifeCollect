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
  self.textView.editable = NO;
  
    [super viewDidLoad];
  mTestStr = @"test str value";
  [self testPointTrans];
  
  
  [self othersTest];
  [self testObjectPropertyDefaultValue];
  [self testObjectPropertyDefaultValue];
  [self testObjectPropertyDefaultValue];
  
  [self showFontOutlineColors];
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
  self.textView.text = [self.textView.text?:@"" stringByAppendingFormat:@"\n%@",theStr];
}

-(void)appendShowStringByFormat:(NSString *)formatStr, ... NS_REQUIRES_NIL_TERMINATION
{
  NSMutableString *fStr = [NSMutableString new];
  if (formatStr){
    va_list arglist;
    va_start(arglist, formatStr);
    id arg;
    while((arg = va_arg(arglist, id))) {
      if (arg)
        [fStr appendString:@"\n"];
        [fStr appendString:arg];
//        formatStr = [formatStr stringByAppendingString:arg];
    }
    va_end(arglist);
  }
  
  self.textView.text = [self.textView.text?:@"%@" stringByAppendingString:fStr];
}

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
  NSMutableString *testStr = [NSMutableString new];
  [testStr appendFormat:@"---- 7&8=%d ----\n\n",7&8];
  [testStr appendFormat:@"---- 7&8=%d ----\n\n",7&8];
  [testStr appendFormat:@"---- 8&0=%d ----\n\n",8&0];
  [testStr appendFormat:@"---- 7&14=%d ----\n\n",7&14];
  [testStr appendFormat:@"---- 3|0=%d ----\n\n",3|0];
  [testStr appendFormat:@"---- 0|0=%d ----\n\n",0|0];
  
  
  [testStr appendFormat:@"---- 7&4=%d ----\n\n",7&4];
  [testStr appendFormat:@"---- 3&2=%d ----\n\n",3&2];
  
  [testStr appendFormat:@"---- 3&1=%d ----\n\n",3&1];
  [testStr appendFormat:@"---- 3|4=%d ----\n\n",3|4];
  [testStr appendFormat:@"---- 1|2=%d ----\n\n",1|2];
  
  [self appendShowString:testStr];
  
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


-(void)showFontOutlineColors
{
  UILabel *text1 = (UILabel*)[self.view viewWithTag:1000];
  
  NSDictionary *tAttrs = @{
                      NSStrokeColorAttributeName : [UIColor blackColor],
                      NSForegroundColorAttributeName : [UIColor greenColor],
                      NSStrokeWidthAttributeName : @(1 * 2) // -1*2 表示 内描边不改变字体颜色
                      };
  text1.attributedText = [[NSAttributedString alloc] initWithString:text1.text attributes:tAttrs];
  
  // -----------------------------
  UILabel *text2 = (UILabel*)[self.view viewWithTag:1001];
  text2.shadowColor = [UIColor blueColor];
  text2.shadowOffset = CGSizeMake(1, 1);
  
  
  
  // -----------------------------
  UILabel *text3 = (UILabel*)[self.view viewWithTag:1002];
  text3.layer.shadowColor = [[UIColor redColor] CGColor];
  text3.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
  text3.layer.shadowOpacity = 1.0f;
  text3.layer.shadowRadius = 1.0f;
  
}



@end

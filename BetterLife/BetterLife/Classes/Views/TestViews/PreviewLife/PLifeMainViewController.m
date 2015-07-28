//
//  PLifeMainViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/5.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//
// 文王64课金钱卦


#import "PLifeMainViewController.h"


#define random_number_plus 64


@interface PLifeMainViewController ()

@property (nonatomic) NSArray *items;

@end

@implementation PLifeMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.textShow.editable = NO;
//  self.textShow.textAlignment = NSTextAlignmentCenter;
  self.textShow.layer.borderWidth = 1;
  self.textShow.layer.borderColor = [UIColor cyanColor].CGColor;
  
  self.btnStart.hidden = NO;
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)actionStart:(UIButton *)sender {
  
  self.textShow.text = @"wait...";
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    uint32_t result = [self findRandomResult:64];
    NSString *showStr = [self findName:result];
    dispatch_async(dispatch_get_main_queue(), ^{
      self.textShow.text = showStr;
    });
  });
  

  
  
}


-(uint32_t)findRandomResult:(uint32_t)theMaxNumber
{
  if (theMaxNumber > 0) {
    NSMutableDictionary * dataDict =[[NSMutableDictionary alloc] initWithCapacity:theMaxNumber];
    int index = theMaxNumber+random_number_plus;
    do {
      int result = abs(random()%theMaxNumber);
      NSNumber *tNum = [dataDict objectForKey:@(result)];
      tNum = tNum?@(tNum.intValue+1):@1;
      [dataDict setObject:tNum forKey:@(result)];
      
    } while (index-- > 0);
    
    NSNumber *key;
    int vNum = 0;
    for (NSNumber *tKey in dataDict.allKeys) {
      NSNumber *tValue = [dataDict objectForKey:tKey];
      if (tValue.intValue > vNum) {
        vNum = tValue.intValue;
        key = tKey;
      }
    }
    NSLog(@"------ key:%@, value:%d ----------",key,vNum);
    return key.intValue;
  }
  return theMaxNumber;
}

-(NSString*)findName:(int)theIndex
{
  if (!self.items) {
    NSString *itemStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wenwang64" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray * allparts = [itemStr componentsSeparatedByString:@"\n"];
    if (allparts.count) {
      NSLog(@"-------- text data load success size:%d -----------------",allparts.count);
      self.items = allparts;
    }
  }
  
 NSString *simple = nil;
  if (self.items.count>(3+theIndex*4)) {
    simple = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",_items[theIndex*4+0],_items[theIndex*4+1],_items[theIndex*4+2],_items[theIndex*4+3]];
  }
  NSLog(@"-------- theIndex :%d, simple:%@ -----------------",theIndex,simple);
  
  return simple;
}

@end

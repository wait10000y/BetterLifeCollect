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
#define replace_bin_char_1 @"X"
#define replace_bin_char_0 @"O"

/*
 XOXXOO
 水泽节卦(斩将封神）
 象曰：时来运转姜太公，登占封神喜气生，到此诸神皆退位，总然有祸不成凶。
 诗曰：太公封神不非凡，谋望求财不费难，交易合伙大吉庆，疾病口舌消除安。
 断曰：月令高强，名声在扬，走失有信，官事无妨。
 */
@interface ShowItem : NSObject

@property (nonatomic) int index; // 序号

@property (nonatomic) int number; //
@property (nonatomic) NSString *series; // XOXXOO
@property (nonatomic) NSString *title; // 水泽节卦(斩将封神)

@property (nonatomic) NSString *content1; // 象曰
@property (nonatomic) NSString *content2; // 诗曰
@property (nonatomic) NSString *content3; // 断曰


@end

@implementation ShowItem

-(NSString*)description
{ 
  return [NSString stringWithFormat:@"%d. %@\n%@\n\n%@\n%@\n%@\n",_index,_title,_series,_content1,_content2,_content3];
}

@end


@interface PLifeMainViewController ()

@property (nonatomic) NSDictionary *dataDict; // key:series;value:ShowItem;

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
    uint32_t result = [self findRandomResult_64gua];
    NSString *showStr = [self findName:result];
    dispatch_async(dispatch_get_main_queue(), ^{
      self.textShow.text = showStr;
    });
  });
  
}

// old
-(uint32_t)findRandomResult:(uint32_t)theMaxNumber
{
  if (theMaxNumber > 0) {
    NSMutableDictionary * dataDict =[[NSMutableDictionary alloc] initWithCapacity:theMaxNumber];
    int index = theMaxNumber+random_number_plus;
    do {
      int result = (arc4random()%theMaxNumber);
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

// special for 64gua
-(int)findRandomResult_64gua
{
  int result = 0;
  for (int it = 0; it< 6; it ++) { // 位
    int index = 4;
    int num = arc4random()%2;
    while (index-- > 0) {
      int t0 = arc4random()%2;
      num += t0;
    }
    if(num%2){
      result += 1<<it;
    }
  }
  return result;
}

-(NSString*)findName:(int)theIndex
{
  if (!self.dataDict) {
    NSString *itemStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wenwang" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray * allparts = [itemStr componentsSeparatedByString:@"\n"];
    if (allparts.count) {
      NSMutableDictionary *dataDict = [NSMutableDictionary new];
      for (int it=0; it<allparts.count; it+=5) {
        NSString *firstStr = allparts[it]; // number
        ShowItem *item = [ShowItem new];
        item.index = it/5+1;
        item.number = [self binString2dec:firstStr];
        item.series = firstStr;
        item.title = allparts[it+1];
        item.content1 = allparts[it+2];
        item.content2 = allparts[it+3];
        item.content3 = allparts[it+4];
        [dataDict setObject:item forKey:firstStr];
      }

      NSLog(@"-------- text data load success size:%lu -----------------",(unsigned long)allparts.count);
      self.dataDict = dataDict;
    }
  }
  
  NSString *series = [self dec2binString:theIndex fixLength:6];
  ShowItem *tempItem = [self.dataDict objectForKey:series];
  
  NSLog(@"-------- theIndex :%@(%d), simple:%@ -----------------",series,theIndex,tempItem);
  return [tempItem description];
}

-(NSString*)dec2binString:(int)theDec fixLength:(uint32_t)theLength
{
  NSMutableString *binStr = [NSMutableString new];
  
  int lDec = theDec;
  while (lDec >0) {
    [binStr insertString:((lDec%2==0)?replace_bin_char_0:replace_bin_char_1) atIndex:0];
//    [binStr appendFormat:@"%d",(lDec%2)];
    lDec = lDec/2;
  }
  if (lDec >0) {
    [binStr appendFormat:@"%d",lDec];
  }
  if (binStr.length < theLength) {
    NSUInteger subLength = theLength-binStr.length;
    while (subLength-- >0) {
      [binStr insertString:replace_bin_char_0 atIndex:0];
    }
  }
  return [NSString stringWithString:binStr];
}

-(int)binString2dec:(NSString*)theStr
{
  int result = 0;
  NSUInteger sLength = theStr.length;
  if (sLength>0) {
    unichar mChar = [replace_bin_char_1 characterAtIndex:0];
    for (int it=(int)(sLength-1); it>=0; it--) {
      unichar tChar = [theStr characterAtIndex:it];
      if (tChar == mChar) {
        result += 1<<(sLength-1-it);
      }
    }
  }
  return result;
}



@end







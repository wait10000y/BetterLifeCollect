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

  self.textDate.text = [self getChineseCalendarWithDate:nil];
  self.btnStart.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)actionStart:(UIButton *)sender {
  
  self.textShow.text = @"wait...";
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSDate *now = [NSDate new];
    uint32_t result = [self findRandomResult_64gua];
    NSString *showStr = [self findTextWithNumber:result];
    NSString *dateStr = [self getChineseCalendarWithDate:now];
    NSLog(@"---- date:%@, text:%@ ----",dateStr,showStr);
    dispatch_async(dispatch_get_main_queue(), ^{
      self.textDate.text = dateStr;
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

-(NSString*)findTextWithNumber:(int)theIndex
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

      NSLog(@"--- text data load success text line:%lu ---",(unsigned long)allparts.count);
      self.dataDict = dataDict;
    }
  }
  
  NSString *series = [self dec2binString:theIndex fixLength:6];
  ShowItem *tempItem = [self.dataDict objectForKey:series];
  
  NSLog(@" ---- \n theIndex :%@(%d), simple:%@ ---- ",series,theIndex,tempItem);
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


#pragma mark --- chinese calendar ---
- (NSString*)getChineseCalendarWithDate:(NSDate *)date{
  
  if (!date) {
    date = [[NSDate alloc] init];
  }
  NSArray *chineseYears = @[@"甲子", @"乙丑", @"丙寅",	@"丁卯",	@"戊辰",	@"己巳",	@"庚午",	@"辛未",	@"壬申",	@"癸酉",
                           @"甲戌",	@"乙亥",	@"丙子",	@"丁丑", @"戊寅",	@"己卯",	@"庚辰",	@"辛己",	@"壬午",	@"癸未",
                           @"甲申",	@"乙酉",	@"丙戌",	@"丁亥",	@"戊子",	@"己丑",	@"庚寅",	@"辛卯",	@"壬辰",	@"癸巳",
                           @"甲午",	@"乙未",	@"丙申",	@"丁酉",	@"戊戌",	@"己亥",	@"庚子",	@"辛丑",	@"壬寅",	@"癸丑",
                           @"甲辰",	@"乙巳",	@"丙午",	@"丁未",	@"戊申",	@"己酉",	@"庚戌",	@"辛亥",	@"壬子",	@"癸丑",
                           @"甲寅",	@"乙卯",	@"丙辰",	@"丁巳",	@"戊午",	@"己未",	@"庚申",	@"辛酉",	@"壬戌",	@"癸亥"];
  
  NSArray *chineseMonths= @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                          @"九月", @"十月", @"冬月", @"腊月"];
  
  
  NSArray *chineseDays=@[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                        @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                        @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
  
  
  NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
  
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  
  NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
  NSLog(@"number:Y:%ld M:%ld D:%ld H:%ld M:%ld S:%ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day,(long)localeComp.hour,(long)localeComp.minute,(long)localeComp.second, localeComp.date);
  
  NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
  NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
  NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  
  NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@%@ (%@)",y_str,m_str,d_str,[df stringFromDate:date]];
  
  return chineseCal_str;
}


@end


//
//  Test@048Utils.m
//  BetterLife
//
//  Created by shiliang.wang on 14/12/22.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "Test2048Utils.h"



#define UIColorRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation Test2048Utils
{
  NSMutableArray *mItemTextColors;
  NSMutableArray *mItemBgColors;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self setDefaultDatas];
  }
  return self;
}

+(instancetype)sharedObject
{
  static dispatch_once_t onceToken;
  static id staticObject = nil;
  dispatch_once(&onceToken, ^{
    staticObject = [Test2048Utils new];
  });
  return staticObject;
}

-(void)setDefaultDatas
{
  return;
  mItemBgColors = [NSMutableArray arrayWithArray:@[
                                                   UIColorRGBHex(0x232323),
                                                   UIColorRGBHex(0x232323),
                                                   UIColorRGBHex(0x232323),
                                                   UIColorRGBHex(0x232323)
                                                   ]];
  
  mItemTextColors = [NSMutableArray arrayWithArray:@[
                                                   UIColorRGBHex(0x232323),
                                                   UIColorRGBHex(0x232323),
                                                   UIColorRGBHex(0x232323),
                                                   UIColorRGBHex(0x232323)
                                                   ]];
  
}

/*
 灰 bc8f8f
 
 03a89e
 
 33a1c9
 
 00c78c
 */
  // =======================================
-(UIColor*)findBodyItemBgColor
{
  return UIColorRGBHex(0xbc8f8f); // 0x00c78c
}

-(int)findItemNextNumber
{
  int tempNumber = 2;
  long tempSize = random();
  if (tempSize%32==0) {
    tempNumber = 8;
  }else if (tempSize%8 == 0){
    tempNumber = 4;
  }
  return tempNumber;
}

-(UIColor*)findItemTextColor:(int)theNumber
{
  return [UIColor whiteColor];
}
-(UIColor*)findItemBgColor:(int)theNumber
{
  return UIColorRGBHex(0x03a89e); // 0x33a1c9
}

-(NSString*)findItemShowNumber:(int)theNumber
{
  return [NSString stringWithFormat:@"%d",theNumber];
}

-(void)printBodyViews:(NSArray*)theItemViews rowNumber:(int)theNum
{
  printf("\n-------------------- body ---------------------\n");
  for (int it=0; it<theItemViews.count; it++) {
    printf("%s\t %d ",(it%theNum==0)?"\n":"",[theItemViews[it] description].intValue);
  }
  printf("\n-------------------- body ---------------------\n");
}


@end

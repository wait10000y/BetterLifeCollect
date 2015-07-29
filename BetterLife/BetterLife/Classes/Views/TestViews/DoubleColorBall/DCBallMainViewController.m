//
//  DCBallMainViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/5.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "DCBallMainViewController.h"


@interface BallItem : NSObject
@property (nonatomic) int index; // 序号

@property (nonatomic) int type; // type: red,green,frount,end...
@property (nonatomic) NSNumber *number; //  value: number...


@end

@implementation BallItem


-(NSString*)description
{
  return [NSString stringWithFormat:@"type:%d, index:%d, number:%@",_type,_index,_number];
}

@end

@interface DCBallMainViewController ()

@end

@implementation DCBallMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

  NSLog(@"=========== %@ ================",[self randomNumbersWithType:PlayingType_shuangseqiu]);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}







-(NSArray*)randomNumbersWithType:(PlayingType)theType
{
  NSArray *balls;
  switch (theType) {
    case PlayingType_shuangseqiu:
    {
      int numberRed = 6;
      int numberBlue = 1;
      NSMutableSet *tBalls = [[NSMutableSet alloc] initWithCapacity:numberRed];
      NSRange redRange = NSMakeRange(1, 33);
      while (numberRed>tBalls.count) {
        int rNum = [self findRedNumbers:redRange];
        [tBalls addObject:@(rNum)];
      }

      NSMutableArray *dBalls = [[NSMutableArray alloc] initWithCapacity:numberRed+numberBlue];
      int index =0;
      for (NSNumber *tNum in tBalls) {
        index ++;
        BallItem *bItem = [BallItem new];
        bItem.type = BallType_red;
        bItem.index = index;
        bItem.number = tNum;
        [dBalls addObject:bItem];
      }
      BallItem *bItem = [BallItem new];
      bItem.type = BallType_blue;
      bItem.index = 1;
      bItem.number = @([self findRedNumbers:NSMakeRange(1, 16)]);
      [dBalls addObject:bItem];
      
      balls = [NSArray arrayWithArray:dBalls];
      
    } break;
    case PlayingType_daletou:
    {
      
    } break;
    case PlayingType_custom:
    {
      
    } break;
      
    default:
      break;
  }
  return balls;
}



// 随机数字[location,location+length]
-(int)findRedNumbers:(NSRange)theRange
{
  return arc4random()%theRange.length+theRange.location;
}




@end

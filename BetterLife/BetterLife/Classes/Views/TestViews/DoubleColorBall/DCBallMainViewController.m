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
@property (nonatomic) NSString *typeName;
@property (nonatomic) NSNumber *number; //  value: number...


@end

@implementation BallItem

-(void)setType:(int)type
{
  _type = type;
  switch (type) {
    case BallType_red:
    {
      _typeName = @"红球";
    } break;
    case BallType_greed:
    {
      _typeName = @"绿球";
    } break;
    case BallType_blue:
    {
      _typeName = @"蓝球";
    } break;
    case BallType_custom:
    {
      _typeName = @"C球";
    } break;
      
    default:
      _typeName = @"白球";
      break;
  }
  
}

-(NSString*)description
{
  return [NSString stringWithFormat:@"NO. %d \t number:%@ \t type:%@ ",_index,_number,_typeName];
}

@end

@interface DCBallMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITextView *textShow;

-(IBAction)actionStartLoad:(UIButton*)sender;

@end

@implementation DCBallMainViewController
{
  int type; // 0:shuangseqiu,1:daletou,2:custom
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  type = 0;
  self.textShow.editable = NO;
  
  [self.segment addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
  
  self.textShow.layer.borderColor = [UIColor blueColor].CGColor;
  self.textShow.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)segmentedControlValueChanged:(UISegmentedControl*)theSender
{
  type = (int)theSender.selectedSegmentIndex;
  self.textShow.text = nil;
}

-(IBAction)actionStartLoad:(UIButton*)sender
{
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *balls = [self randomNumbersWithType:type];
    NSMutableString *showStr = [NSMutableString new];
    for (int it=0; it<balls.count; it++) {
      BallItem *item = balls[it];
      [showStr appendFormat:@"%@\n",item];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      self.textShow.text = showStr;
    });
  });
  
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
      
      int numberRed = 5;
      int numberBlue = 2;
      NSMutableSet *rBalls = [[NSMutableSet alloc] initWithCapacity:numberRed];
      NSRange rRange = NSMakeRange(1, 33);
      while (numberRed>rBalls.count) {
        int rNum = [self findRedNumbers:rRange];
        [rBalls addObject:@(rNum)];
      }
      
      NSMutableSet *bBalls = [[NSMutableSet alloc] initWithCapacity:numberBlue];
      NSRange bRange = NSMakeRange(1, 16);
      while (numberRed>bBalls.count) {
        int rNum = [self findRedNumbers:bRange];
        [bBalls addObject:@(rNum)];
      }
      
      NSMutableArray *dBalls = [[NSMutableArray alloc] initWithCapacity:numberRed+numberBlue];
      int index =0;
      for (NSNumber *tNum in rBalls) {
        index ++;
        BallItem *bItem = [BallItem new];
        bItem.type = BallType_red;
        bItem.index = index;
        bItem.number = tNum;
        [dBalls addObject:bItem];
      }
      index =0;
      for (NSNumber *tNum in bBalls) {
        index ++;
        BallItem *bItem = [BallItem new];
        bItem.type = BallType_blue;
        bItem.index = index;
        bItem.number = tNum;
        [dBalls addObject:bItem];
      }
      
      balls = [NSArray arrayWithArray:dBalls];
    } break;
    case PlayingType_custom:
    {
      
      NSMutableArray *dBalls = [[NSMutableArray alloc] initWithCapacity:3];
      NSRange dRange = NSMakeRange(0, 9);
      for (int it=1;it<=3; it++) {
        BallItem *item = [BallItem new];
        item.type = BallType_custom;
        item.index = it;
        item.number = @([self findRedNumbers:dRange]);
        [dBalls addObject:item];
      }
      balls = [NSArray arrayWithArray:dBalls];
    } break;
      
    default:
      break;
  }
  return balls;
}



// 随机数字[location,location+length]
-(int)findRedNumbers:(NSRange)theRange
{
  return arc4random()%theRange.length+(int)theRange.location;
}




@end

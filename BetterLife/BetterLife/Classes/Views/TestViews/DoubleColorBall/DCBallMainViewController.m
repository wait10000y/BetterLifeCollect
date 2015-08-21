//
//  DCBallMainViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/5.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "DCBallMainViewController.h"


@interface BallItem : NSObject
@property (nonatomic) NSString *redBallName;
@property (nonatomic) NSString *greenBallName;
@property (nonatomic) NSString *blueBallName;
@property (nonatomic) NSArray *redBalls; // NSNumbers
@property (nonatomic) NSArray *greenBalls;// NSNumbers
@property (nonatomic) NSArray *blueBalls;// NSNumbers

-(NSString*)NaturallyString;
-(NSString*)sortedString;

@end

@implementation BallItem

-(NSString*)NaturallyString
{
  NSMutableString *tempStr = [NSMutableString new];
  if (self.redBalls) {
    [tempStr appendFormat:@" %@:%@",self.redBallName?:@"号码",[self arrayToString:self.redBalls minLength:2 splitString:@","]];
    [tempStr appendString:@"\t"];
  }
  if (self.greenBalls) {
    [tempStr appendFormat:@" %@:%@",self.greenBallName?:@"号码",[self arrayToString:self.greenBalls minLength:2 splitString:@","]];
    [tempStr appendString:@"\t"];
  }
  if (self.blueBalls) {
    [tempStr appendFormat:@" %@:%@",self.blueBallName?:@"号码",[self arrayToString:self.blueBalls minLength:2 splitString:@","]];
    [tempStr appendString:@"\t"];
  }
  return [tempStr description];
}
-(NSString*)sortedString
{
  NSMutableString *tempStr = [NSMutableString new];
  
  if (self.redBalls) {
    NSArray *tempArr = [self.redBalls sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
      return [obj1 compare:obj2];
    }];
    [tempStr appendFormat:@" %@:%@",self.redBallName?:@"号码",[self arrayToString:tempArr minLength:2 splitString:@","]];
  }
  if (self.greenBalls) {
    NSArray *tempArr = [self.greenBalls sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
      return [obj1 compare:obj2];
    }];
    [tempStr appendFormat:@" %@:%@",self.greenBallName?:@"号码",[self arrayToString:tempArr minLength:2 splitString:@","]];
  }
  if (self.blueBalls) {
    NSArray *tempArr = [self.blueBalls sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
      return [obj1 compare:obj2];
    }];
    [tempStr appendFormat:@" %@:%@",self.blueBallName?:@"号码",[self arrayToString:tempArr minLength:2 splitString:@","]];
  }
  return [tempStr description];
}

-(NSString *)arrayToString:(NSArray*)theArr minLength:(NSInteger)theLength splitString:(NSString*)theSplitStr
{
  if (theArr.count) {
    NSMutableString *tempStr = [NSMutableString new];
    for (int it=0; it<theArr.count; it++) {
      NSString *temp = [theArr[it] description];
      if (temp.length < theLength) {
        NSInteger tLength = theLength-temp.length;
        while (tLength-- >0) {
          [tempStr appendString:@" "];
        }
      }
      [tempStr appendString:temp];
      if (it < theArr.count-1) {
        [tempStr appendString:theSplitStr];
      }
    }
    return [NSString stringWithString:tempStr];
  }
  return nil;
}

@end


@interface DCBallMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UITextView *textShow;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentNumber;
@property (weak, nonatomic) IBOutlet UISwitch *sortTag;

-(IBAction)actionStartLoad:(UIButton*)sender;
- (IBAction)actionValueChanged:(UISwitch *)sender;

@end

@implementation DCBallMainViewController
{
  NSInteger type; // 0:shuangseqiu,1:daletou,2:custom
  NSString*typeName;
  
 NSInteger createNumber;
  BOOL isSortNumber;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.textShow.editable = NO;
  self.sortTag.on = YES;
  
  type = self.segment.selectedSegmentIndex;
  typeName = [self.segment titleForSegmentAtIndex:type];
  
  createNumber = [[self.segmentNumber titleForSegmentAtIndex:self.segmentNumber.selectedSegmentIndex] integerValue];
  isSortNumber = self.sortTag.on;
  
  self.segment.tintColor = [UIColor redColor];
  self.segmentNumber.tintColor = [UIColor redColor];
  [self.segment addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
  [self.segmentNumber addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
  self.textShow.layer.borderColor = [UIColor redColor].CGColor;
  self.textShow.layer.borderWidth = 1.0f;
  
  [self showString:[NSString stringWithFormat:@"-------- %@ --------\n",typeName] isAppend:NO];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)segmentedControlValueChanged:(UISegmentedControl*)theSender
{
  if (theSender == self.segment) {
    type = theSender.selectedSegmentIndex;
    typeName = [theSender titleForSegmentAtIndex:type];
    if (type == PlayingType_custom) {
      self.sortTag.on = NO;
      self.sortTag.enabled = NO;
    }else{
      self.sortTag.enabled = YES;
    }
    [self showString:[NSString stringWithFormat:@"-------- %@ --------\n",typeName] isAppend:NO];
  }else if (theSender == self.segmentNumber){
    createNumber = [[self.segmentNumber titleForSegmentAtIndex:self.segmentNumber.selectedSegmentIndex] integerValue];
  }
}

-(IBAction)actionStartLoad:(UIButton*)sender
{
  if (sender.tag == 100) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSArray *balls = [self randomNumbersWithType:type withNumber:createNumber];
      NSMutableString *showStr = [NSMutableString new];
      //    [showStr appendString:typeName];
      for (int it=0; it<balls.count; it++) {
        BallItem *item = balls[it];
        [showStr appendFormat:@"%@\n",isSortNumber?[item sortedString]:[item NaturallyString]];
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        [self showString:showStr isAppend:YES];
      });
    });
  }else if (sender.tag == 101){ // cleaer
    [self showString:[NSString stringWithFormat:@"-------- %@ --------\n",typeName] isAppend:NO];
  }
  
}

- (IBAction)actionValueChanged:(UISwitch *)sender {
  isSortNumber = sender.on;
}


// type:类型
// number:个数
-(NSArray*)randomNumbersWithType:(PlayingType)theType withNumber:(NSInteger)theNumber
{
  NSArray *balls;
  switch (theType) {
    case PlayingType_shuangseqiu:
    {
      balls = [self shuangSeQiu:theNumber];
    } break;
    case PlayingType_daletou:
    {
      
      balls = [self daLeTou:theNumber];
    } break;
    case PlayingType_custom:
    {
      
      balls = [self sanDi:theNumber];
    } break;
      
    default:
      break;
  }
  return balls;
}

// ------------ utils ---------------

-(NSArray*)shuangSeQiu:(NSInteger)theNum
{
  if (theNum >0) {
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:theNum];
    for (int it=0; it<theNum; it++) {
      NSArray *redBalls = [self createBallsWithRange:NSMakeRange(1, 33) withNumber:6 isUnique:YES];
      BallItem *item = [BallItem new];
      item.redBallName = @"红球";
      item.blueBallName = @"蓝球";
      item.redBalls = redBalls;
      item.blueBalls = @[@([self findRedNumbers:NSMakeRange(1, 16)])];
      [itemList addObject:item];
    }
    return itemList;
  }
  return nil;
}

-(NSArray*)daLeTou:(NSInteger)theNum
{
  if (theNum >0) {
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:theNum];
    for (int it=0; it<theNum; it++) {
      NSArray *redBalls = [self createBallsWithRange:NSMakeRange(1, 33) withNumber:6 isUnique:YES];
      NSArray *blueBalls = [self createBallsWithRange:NSMakeRange(1, 16) withNumber:2 isUnique:YES];
      BallItem *item = [BallItem new];
      item.redBallName = @"前区";
      item.blueBallName = @"后区";
      item.redBalls = redBalls;
      item.blueBalls = blueBalls;
      [itemList addObject:item];
    }
    return itemList;
  }
  return nil;
}

-(NSArray*)sanDi:(NSInteger)theNum
{
  if (theNum >0) {
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:theNum];
    for (int it=0; it<theNum; it++) {
      NSArray *redBalls = [self createBallsWithRange:NSMakeRange(0, 9) withNumber:3 isUnique:NO];
      BallItem *item = [BallItem new];
      item.redBallName = @"号码";
      item.redBalls = redBalls;
      [itemList addObject:item];
    }
    return itemList;
  }
  return nil;
}

-(NSArray*)createBallsWithRange:(NSRange)theRange withNumber:(int)theNumber isUnique:(BOOL)isUnique
{
  if ((isUnique && theRange.length < theNumber) || theNumber <= 0) {
    return nil;
  }

  NSMutableArray *redBalls = [[NSMutableArray alloc] initWithCapacity:theNumber];
  while (theNumber>redBalls.count) {
    NSNumber *rNum = @([self findRedNumbers:theRange]);
    if (!isUnique || (isUnique && ![redBalls containsObject:rNum])) {
      [redBalls addObject:rNum];
    }
  }
  return redBalls;
}


// 随机数字[location,location+length]
-(int)findRedNumbers:(NSRange)theRange
{
  return arc4random()%theRange.length+(int)theRange.location;
}


-(void)showString:(NSString*)theValues isAppend:(BOOL)isAppend
{
  if (isAppend) {
    self.textShow.text = [NSString stringWithFormat:@"%@\n%@",self.textShow.text,theValues];
  }else{
    self.textShow.text = [theValues description];
  }
}


@end

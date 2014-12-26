//
//  Test2048ViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14-12-10.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "Test2048ViewController.h"
#import "Test2048ItemView.h"
#import "Test2048Utils.h"

struct Test2048ItemSize {
  int width;
  int height;
};
typedef struct Test2048ItemSize Test2048ItemSize;

#define titleBtnStartNormal     @"开始"
#define titleBtnStartReStart    @"重新开始"
#define titleBtnUndoNormal      @"上一步"
#define titleBtnSettings        @"设置"
#define titlescoreNumberNow     @"本局分数"
#define titleScoreNumberTall    @"最高分数"



@interface Test2048ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnUndo;

@property (weak, nonatomic) IBOutlet UILabel *scoreNow;
@property (weak, nonatomic) IBOutlet UILabel *scoreTall;
@property (weak, nonatomic) IBOutlet UILabel *scoreNowTitle;
@property (weak, nonatomic) IBOutlet UILabel *scoreTallTitle;

@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UIView *viewBody;

- (IBAction)actionBtnPress:(UIButton *)sender;
- (IBAction)actionSwipe:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeItem;

@end

@implementation Test2048ViewController
{
  NSMutableArray *itemList;
  NSMutableArray *itemListNoTags;
  Test2048ItemSize itemSize;
//  NSMutableArray *itemListRow;
  NSMutableArray *recordList;
  int scoreNumberNow;
  
  int nextNumber;
  BOOL isStarted;
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
  NSLog(@"-----infoView:%@,bodyView:%@ -----",NSStringFromCGRect(self.viewInfo.frame),NSStringFromCGRect(self.viewBody.frame));
  [self setDefaultInitValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDefaultInitValue
{
  isStarted = NO;
  
  [self.btnStart setTitle:titleBtnStartNormal forState:UIControlStateNormal];
  [self.btnUndo setTitle:titleBtnUndoNormal forState:UIControlStateNormal];
  self.btnUndo.enabled = NO;
  self.scoreNowTitle.text = titlescoreNumberNow;
  self.scoreTallTitle.text = titleScoreNumberTall;
  self.scoreNow.text = @"0";
  self.scoreTall.text = @"0";
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Test2048_back1"]];
  
  self.viewBody.layer.cornerRadius = 4;
  self.viewBody.layer.masksToBounds = YES;
//  self.viewBody.layer.borderWidth = 1;
//  self.viewBody.layer.borderColor = [UIColor lightGrayColor].CGColor;
  
  [self createItemViewsWithNumbers:(Test2048ItemSize){4,4} withSpace:5];
}

- (IBAction)actionBtnPress:(UIButton *)sender {
  if (sender.tag == 1001) { // start
    if (isStarted) {
      [self reStartPlay];
    }else{
      [self startPlay];
    }
    [sender setTitle:titleBtnStartReStart forState:UIControlStateNormal];
    
  }else if(sender.tag == 1002){ // unDo
    [self popRecordData];
  }
  
  NSLog(@"------------ actionBtnPress:%ld ---------------",(long)sender.tag);
}

/*
 UISwipeGestureRecognizerDirectionRight = 1 << 0,
 UISwipeGestureRecognizerDirectionLeft  = 1 << 1,
 UISwipeGestureRecognizerDirectionUp    = 1 << 2,
 UISwipeGestureRecognizerDirectionDown  = 1 << 3
 */
- (IBAction)actionSwipe:(UISwipeGestureRecognizer *)sender {
  [self moveItemsWithDirection:sender.direction];
}

  // size.width line,row
-(void)createItemViewsWithNumbers:(Test2048ItemSize)theSize withSpace:(float)theSpace
{
  for (UIView *tempView in self.viewBody.subviews) {
    [tempView removeFromSuperview];
  }
  itemSize = theSize;
  itemList = [[NSMutableArray alloc] initWithCapacity:theSize.width*theSize.height];
  itemListNoTags = [[NSMutableArray alloc] initWithCapacity:theSize.width*theSize.height];
//  itemListCol = [[NSMutableArray alloc] initWithCapacity:theSize.width];
//  itemListRow = [[NSMutableArray alloc] initWithCapacity:theSize.height];
  
  CGRect bodyFrame = self.viewBody.frame;
  float itemWidth = (bodyFrame.size.width)/theSize.width-theSpace;
  float itemHeight = (bodyFrame.size.height)/theSize.height-theSpace;
  float boardSpace = theSpace/2;
  for (int jt=0; jt<theSize.height; jt++) {
    for (int it=0; it<theSize.width; it++) {
      CGRect itemFrame = CGRectMake(boardSpace+it*(itemWidth+theSpace), boardSpace+jt*(itemHeight+theSpace), itemWidth,itemHeight);
      Test2048ItemView *tempItem = [[Test2048ItemView alloc] initWithFrame:itemFrame];
      [self.viewBody addSubview:tempItem];
      [itemList addObject:tempItem];
      [itemListNoTags addObject:tempItem];
    }
  }
  
}

-(void)reStartPlay
{
  if (itemList.count>0) {
    for (Test2048ItemView *tempView in itemList) {
      [tempView emptyView];
      [itemListNoTags addObject:tempView];
    }
  }
  [self startPlay];
}

-(void)startPlay
{
  isStarted = YES;
  [self createAndFillNewItem];
  [self createAndFillNewItem];
  [self printBodyViews];
  
  scoreNumberNow = 0;
  recordList = [NSMutableArray new];
  self.scoreNow.text = [NSString stringWithFormat:@"%d",scoreNumberNow];
  self.btnUndo.enabled = YES;
}

-(BOOL)createAndFillNewItem
{
    //  int index = arc4random_uniform(itemListNoTags.count);
  if (itemListNoTags.count) {
    Test2048ItemView *temp1 = itemListNoTags[random()%itemListNoTags.count];
    int newNumber = [self findItemNextNumber];
    [temp1 updateView:newNumber
           showNumber:[self findItemShowNumber:newNumber]
            textColor:[self findItemTextColor:newNumber]
              bgColor:[self findItemBgColor:newNumber]];
    [itemListNoTags removeObject:temp1];
    return YES;
  }
  return NO;
}

//检查是否还有可以合并的块
-(BOOL)checkCouldMoveNextItem
{
  if (itemListNoTags.count>0) {
    return YES;
  }
  
  for (int it=1; it< itemSize.width; it+=2) {
    for (int jt=0; jt<itemSize.height; jt++) {
      Test2048ItemView *tempItemP = itemList[it-1+jt*itemSize.width];
      Test2048ItemView *tempItem = itemList[it+jt*itemSize.width];
      if (tempItem.mNumber == tempItemP.mNumber) {
        return YES;
      }
      int nextIndex = it+1+jt*itemSize.width;
      if (nextIndex<itemList.count) {
        Test2048ItemView *tempItemN = itemList[nextIndex];
        if (tempItem.mNumber == tempItemN.mNumber) {
          return YES;
        }
      }
    }
  }
  
  for (int it=1; it< itemSize.height; it+=2) {
    for (int jt=0; jt<itemSize.width; jt++) {
      Test2048ItemView *tempItemP = itemList[(it-1)*itemSize.width+jt];
      Test2048ItemView *tempItem = itemList[it*itemSize.width+jt];
      if (tempItem.mNumber == tempItemP.mNumber) {
        return YES;
      }
      int nextIndex = (it+1)*itemSize.width+jt;
      if (nextIndex<itemList.count) {
        Test2048ItemView *tempItemN = itemList[nextIndex];
        if (tempItem.mNumber == tempItemN.mNumber) {
          return YES;
        }
      }
    }
  }
  
  return NO;
}

-(BOOL)recordNowDatas
{
  NSMutableArray *numbers = [[NSMutableArray alloc] initWithCapacity:itemList.count];
  for (int it=0; it<itemList.count; it++) {
    Test2048ItemView *tempView = itemList[it];
    [numbers addObject:@(tempView.mNumber)];
  }
  Test2048RecordItem *tempRecord = [Test2048RecordItem recordWithDatas:[NSArray arrayWithArray:numbers] scrose:scoreNumberNow];
  [recordList addObject:tempRecord];
  return YES;
}

-(BOOL)popRecordData
{
  if (recordList.count>1) {
    [recordList removeLastObject];
    Test2048RecordItem *tempRecord = [recordList lastObject];
    [itemListNoTags removeAllObjects];
    for (int it=0; it<itemList.count; it++) {
      Test2048ItemView *tempView = itemList[it];
      NSNumber *tempNum = tempRecord.bodyDatas[it];
      int num = tempNum.intValue;
      if (num) {
        [tempView updateView:num
                  showNumber:[self findItemShowNumber:num]
                   textColor:[self findItemTextColor:num]
                     bgColor:[self findItemBgColor:num]];
      }else{
        [tempView emptyView];
        [itemListNoTags addObject:tempView];
      }
    }
    self.scoreNow.text = [NSString stringWithFormat:@"%d",tempRecord.scrose];
    return YES;
  }
  return NO;
}

-(void)moveItemsWithDirection:(UISwipeGestureRecognizerDirection)theDirection
{
  BOOL isMoveOk;
  switch (theDirection) {
    case UISwipeGestureRecognizerDirectionRight:
    {
      isMoveOk = [self turnRightItems];
    }break;
    case UISwipeGestureRecognizerDirectionLeft:
    {
      isMoveOk = [self turnLeftItems];
    }break;
    case UISwipeGestureRecognizerDirectionUp:
    {
      isMoveOk = [self turnTopItems];
    }break;
    case UISwipeGestureRecognizerDirectionDown:
    {
      isMoveOk = [self turnButtomItems];
    }break;
      
    default:
      isMoveOk = NO;
      break;
  }
  if (!isMoveOk && itemListNoTags.count) {return;}
  
  scoreNumberNow +=1;
  self.scoreNow.text = [NSString stringWithFormat:@"%d",scoreNumberNow];
  
    // create new one
 BOOL isCreate = [self createAndFillNewItem];
  if (!isCreate) {
    NSLog(@"----------- create new item error --------------");
      // 检查 是否已经结束
    if (![self checkCouldMoveNextItem]) {
      NSLog(@"------- game over --------");
      [[[UIAlertView alloc] initWithTitle:nil message:@"game over" delegate:nil cancelButtonTitle:@"确   定" otherButtonTitles:nil, nil] show];
    }
  }else{
    [self recordNowDatas];
  }
  [self printBodyViews];
}

// right
-(BOOL)turnRightItems
{
  BOOL isEffected = NO;
  for (int jt=0; jt<itemSize.height; jt++) {
      // 合并数据
    for (int it=itemSize.width-1; it>=0;it--) {
      if (it==0) {break;}
      Test2048ItemView *tempItem1 = itemList[jt*itemSize.width+it];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = itemList[jt*itemSize.width+kt];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      NSLog(@"--- right  \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*itemSize.width+it),it+1,jt+1,tempItem1,(jt*itemSize.width+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        int tempNumber = tempItem1.mNumber;
        tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[self findItemShowNumber:tempNumber]
                    textColor:[self findItemTextColor:tempNumber]
                      bgColor:[self findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [itemListNoTags addObject:tempItem2];
        it= index;
        isEffected = YES;
      }else{
        it= index+1;
      }
    }
    
      // 右移数据块
    for (int it=itemSize.width-1; it>=0; it--) {
      Test2048ItemView *tempItem1 = itemList[jt*itemSize.width+it];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = itemList[jt*itemSize.width+kt];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
        break; // 没有需要移动的item
      }
      
        // 交换数据
      [tempItem1 updateView:tempItem2.mNumber showNumber:tempItem2.mShowNumber textColor:tempItem2.mTextColor bgColor:tempItem2.mBgColor];
      [tempItem2 emptyView];
      [itemListNoTags removeObject:tempItem1];
      [itemListNoTags addObject:tempItem2];
      isEffected = YES;
    }
  }
  return isEffected;
}

  // left
-(BOOL)turnLeftItems
{
  BOOL isEffected = NO;
  for (int jt=0; jt<itemSize.height; jt++) {
      // 合并数据
    for (int it=0; it<itemSize.width;it++) {
      if (it== itemSize.width-1) {break;}
      Test2048ItemView *tempItem1 = itemList[jt*itemSize.width+it];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<itemSize.width; kt++) {
        tempItem2 = itemList[jt*itemSize.width+kt];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      NSLog(@"--- left  \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*itemSize.width+it),it+1,jt+1,tempItem1,(jt*itemSize.width+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        int tempNumber = tempItem1.mNumber;
        tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[self findItemShowNumber:tempNumber]
                    textColor:[self findItemTextColor:tempNumber]
                      bgColor:[self findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [itemListNoTags addObject:tempItem2];
        it= index;
        isEffected = YES;
      }else{
        it=index-1;
      }
    }
    
      // 左移数据块
    for (int it=0; it<itemSize.width; it++) {
      Test2048ItemView *tempItem1 = itemList[jt*itemSize.width+it];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<itemSize.width; kt++) {
        tempItem2 = itemList[jt*itemSize.width+kt];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
        break; // 没有需要移动的item
      }
      
        // 交换数据
      [tempItem1 updateView:tempItem2.mNumber showNumber:tempItem2.mShowNumber textColor:tempItem2.mTextColor bgColor:tempItem2.mBgColor];
      [tempItem2 emptyView];
      [itemListNoTags removeObject:tempItem1];
      [itemListNoTags addObject:tempItem2];
      isEffected = YES;
    }
  }
  return isEffected;
}

  // top
-(BOOL)turnTopItems
{
  BOOL isEffected = NO;
  for (int jt=0; jt<itemSize.width; jt++) {
      // 合并数据
    for (int it=0; it<itemSize.height;it++) {
      if (it== itemSize.height-1) {break;}
      Test2048ItemView *tempItem1 = itemList[jt+it*itemSize.width];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<itemSize.height; kt++) {
        tempItem2 = itemList[jt+kt*itemSize.width];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      
      NSLog(@"--- top   \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*itemSize.width+it),it+1,jt+1,tempItem1,(jt*itemSize.width+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        int tempNumber = tempItem1.mNumber;
        tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[self findItemShowNumber:tempNumber]
                    textColor:[self findItemTextColor:tempNumber]
                      bgColor:[self findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [itemListNoTags addObject:tempItem2];
        it= index;
        isEffected = YES;
      }else{
        it=index-1;
      }
    }
    
      // 左移数据块
    for (int it=0; it<itemSize.height; it++) {
      Test2048ItemView *tempItem1 = itemList[jt+it*itemSize.width];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<itemSize.height; kt++) {
        tempItem2 = itemList[jt+kt*itemSize.width];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
        break; // 没有需要移动的item
      }
      
        // 交换数据
      [tempItem1 updateView:tempItem2.mNumber
                 showNumber:tempItem2.mShowNumber
                  textColor:tempItem2.mTextColor
                    bgColor:tempItem2.mBgColor];
      [tempItem2 emptyView];
      [itemListNoTags removeObject:tempItem1];
      [itemListNoTags addObject:tempItem2];
      isEffected = YES;
    }
  }
  return isEffected;
}

  // buttom
-(BOOL)turnButtomItems
{
  BOOL isEffected = NO;
  for (int jt=0; jt<itemSize.width; jt++) {
      // 合并数据
    for (int it=itemSize.height-1; it>=0;it--) {
      if (it==0) {break;}
      Test2048ItemView *tempItem1 = itemList[jt+it*itemSize.width];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = itemList[jt+kt*itemSize.width];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      NSLog(@"--- buttom  \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*itemSize.width+it),it+1,jt+1,tempItem1,(jt*itemSize.width+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        int tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[self findItemShowNumber:tempNumber]
                    textColor:[self findItemTextColor:tempNumber]
                      bgColor:[self findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [itemListNoTags addObject:tempItem2];
        it= index;
        isEffected = YES;
      }else{
        it=index+1;
      }
    }
    
      // 下移数据块
    for (int it=itemSize.height-1; it>=0; it--) {
      Test2048ItemView *tempItem1 = itemList[jt+it*itemSize.width];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = itemList[jt+kt*itemSize.width];
        if (!tempItem2.mEmpty) {
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
        break; // 没有需要移动的item
      }
      
        // 交换数据
      [tempItem1 updateView:tempItem2.mNumber
                 showNumber:tempItem2.mShowNumber
                  textColor:tempItem2.mTextColor
                    bgColor:tempItem2.mBgColor];
      [tempItem2 emptyView];
      [itemListNoTags removeObject:tempItem1];
      [itemListNoTags addObject:tempItem2];
      isEffected = YES;
    }
  }
  return isEffected;
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
  return [UIColor blueColor];
}
-(UIColor*)findItemBgColor:(int)theNumber
{
  return [UIColor darkGrayColor];
}

-(NSString*)findItemShowNumber:(int)theNumber
{
  return [NSString stringWithFormat:@"%d",theNumber];
}

-(void)printBodyViews
{
  printf("\n-------------------- body ---------------------\n");
  for (int it=0; it<itemList.count; it++) {
    Test2048ItemView *tempView = itemList[it];
    printf("%s\t %d ",(it%itemSize.width==0)?"\n":"",tempView.mNumber);
  }
  printf("\n-------------------- body ---------------------\n");
}

@end



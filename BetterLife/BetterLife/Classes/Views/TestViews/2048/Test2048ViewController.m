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
  NSMutableArray *mItemListAll;
  NSMutableArray *mItemListEmpty;
  Test2048ItemTable mBodyTable;
  NSMutableArray *mRecordList;
  int scoreNumberNow;
  int scoreNumberTal;
  int scoreNumberStep;
  int nextNumber;
  BOOL isStarted;
  test2048MoveResult moveResult;
  __weak Test2048Utils *mUtils;
  BOOL isInitFrameData;
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
  BaseDefineNavigationController *bdncv = (BaseDefineNavigationController*)self.navigationController;
  bdncv.canDragBack = NO;
  bdncv.specialPop = NO;
//  NSLog(@"-----infoView:%@,bodyView:%@ -----",NSStringFromCGRect(self.viewInfo.frame),NSStringFromCGRect(self.viewBody.frame));

}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (!isInitFrameData) {
    scoreNumberNow = 0;
    scoreNumberTal = 0;
    scoreNumberStep = 0;
//  moveResult.score = 0;
//  moveResult.hasMoved = NO;
    [self setDefaultInitValue];
    isInitFrameData = YES;
  }
}

-(void)viewDidDisappear:(BOOL)animated
{
  BaseDefineNavigationController *bdncv = (BaseDefineNavigationController*)self.navigationController;
  bdncv.canDragBack = YES;
  bdncv.specialPop = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDefaultInitValue
{
  isStarted = NO;
  mUtils = [Test2048Utils sharedObject];
  
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
  self.viewBody.backgroundColor = [UIColor lightGrayColor];
  
  [self createItemViewsWithNumbers:(Test2048ItemTable){4,4} withSpace:5];
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
-(void)createItemViewsWithNumbers:(Test2048ItemTable)theTable withSpace:(float)theSpace
{
  for (UIView *tempView in self.viewBody.subviews) {
    [tempView removeFromSuperview];
  }
  mBodyTable = theTable;
  mItemListAll = [[NSMutableArray alloc] initWithCapacity:mBodyTable.row*mBodyTable.col];
  mItemListEmpty = [[NSMutableArray alloc] initWithCapacity:mBodyTable.row*mBodyTable.col];
//  mItemListAllCol = [[NSMutableArray alloc] initWithCapacity:mBodyTable.row];
//  mItemListAllRow = [[NSMutableArray alloc] initWithCapacity:mBodyTable.col];
  
  CGRect bodyFrame = self.viewBody.frame;
  float itemWidth = (bodyFrame.size.width)/mBodyTable.row-theSpace;
  float itemHeight = (bodyFrame.size.height)/mBodyTable.col-theSpace;
  float boardSpace = theSpace/2;
  for (int jt=0; jt<mBodyTable.col; jt++) {
    for (int it=0; it<mBodyTable.row; it++) {
      CGRect itemFrame = CGRectMake(boardSpace+it*(itemWidth+theSpace), boardSpace+jt*(itemHeight+theSpace), itemWidth,itemHeight);
      Test2048ItemView *tempItem = [[Test2048ItemView alloc] initWithFrame:itemFrame];
      [self.viewBody addSubview:tempItem];
    }
  }
  
  for (int jt=0; jt<mBodyTable.col; jt++) {
    for (int it=0; it<mBodyTable.row; it++) {
      CGRect itemFrame = CGRectMake(boardSpace+it*(itemWidth+theSpace), boardSpace+jt*(itemHeight+theSpace), itemWidth,itemHeight);
      Test2048ItemView *tempItem = [[Test2048ItemView alloc] initWithFrame:itemFrame];
//      [self.viewBody.layer addSublayer:[[CALayer alloc] initWithLayer:tempItem.layer]];
      [self.viewBody addSubview:tempItem];
      [mItemListAll addObject:tempItem];
      [mItemListEmpty addObject:tempItem];
    }
  }
  
}

-(void)reStartPlay
{
  if (mItemListAll.count>0) {
    for (Test2048ItemView *tempView in mItemListAll) {
      [tempView emptyView];
      [mItemListEmpty addObject:tempView];
    }
  }
  [self startPlay];
}

-(void)startPlay
{
  isStarted = YES;
  [self createAndFillNewItem];
  [self createAndFillNewItem];
  [mUtils printBodyViews:mItemListAll rowNumber:mBodyTable.row];
  
  scoreNumberNow = 0;
  mRecordList = [NSMutableArray new];
  self.scoreNow.text = [NSString stringWithFormat:@"%d",scoreNumberNow];
  self.btnUndo.enabled = YES;
}

-(BOOL)createAndFillNewItem
{
    //  int index = arc4random_uniform(mItemListEmpty.count);
  if (mItemListEmpty.count) {
    Test2048ItemView *temp1 = mItemListEmpty[random()%mItemListEmpty.count];
    int newNumber = [mUtils findItemNextNumber];
    [temp1 updateView:newNumber
           showNumber:[mUtils findItemShowNumber:newNumber]
            textColor:[mUtils findItemTextColor:newNumber]
              bgColor:[mUtils findItemBgColor:newNumber]];
    [mItemListEmpty removeObject:temp1];
    return YES;
  }
  return NO;
}

//检查是否还有可以合并的块
-(BOOL)checkCouldMoveNextItem
{
  if (mItemListEmpty.count>0) {
    return YES;
  }
  
  for (int it=1; it< mBodyTable.row; it+=2) {
    for (int jt=0; jt<mBodyTable.col; jt++) {
      Test2048ItemView *tempItemP = mItemListAll[it-1+jt*mBodyTable.row];
      Test2048ItemView *tempItem = mItemListAll[it+jt*mBodyTable.row];
      if (tempItem.mNumber == tempItemP.mNumber) {
        return YES;
      }
      int nextIndex = it+1+jt*mBodyTable.row;
      if (it+1<mBodyTable.row) {
        Test2048ItemView *tempItemN = mItemListAll[nextIndex];
        if (tempItem.mNumber == tempItemN.mNumber) {
          return YES;
        }
      }
    }
  }
  
  for (int it=1; it< mBodyTable.col; it+=2) {
    for (int jt=0; jt<mBodyTable.row; jt++) {
      Test2048ItemView *tempItemP = mItemListAll[(it-1)*mBodyTable.row+jt];
      Test2048ItemView *tempItem = mItemListAll[it*mBodyTable.row+jt];
      if (tempItem.mNumber == tempItemP.mNumber) {
        return YES;
      }
      int nextIndex = (it+1)*mBodyTable.row+jt;
      if (it+1<mBodyTable.col) {
        Test2048ItemView *tempItemN = mItemListAll[nextIndex];
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
  NSMutableArray *numbers = [[NSMutableArray alloc] initWithCapacity:mItemListAll.count];
  for (int it=0; it<mItemListAll.count; it++) {
    Test2048ItemView *tempView = mItemListAll[it];
    [numbers addObject:@(tempView.mNumber)];
  }
  Test2048RecordItem *tempRecord = [Test2048RecordItem recordWithDatas:[NSArray arrayWithArray:numbers] scrose:scoreNumberNow];
  [mRecordList addObject:tempRecord];
  return YES;
}

-(BOOL)popRecordData
{
  if (mRecordList.count>1) {
    [mRecordList removeLastObject];
    Test2048RecordItem *tempRecord = [mRecordList lastObject];
    [mItemListEmpty removeAllObjects];
    for (int it=0; it<mItemListAll.count; it++) {
      Test2048ItemView *tempView = mItemListAll[it];
      NSNumber *tempNum = tempRecord.bodyDatas[it];
      int num = tempNum.intValue;
      if (num) {
        [tempView updateView:num
                  showNumber:[mUtils findItemShowNumber:num]
                   textColor:[mUtils findItemTextColor:num]
                     bgColor:[mUtils findItemBgColor:num]];
      }else{
        [tempView emptyView];
        [mItemListEmpty addObject:tempView];
      }
    }
    scoreNumberNow = tempRecord.scrose;
    self.scoreNow.text = [NSString stringWithFormat:@"%d",tempRecord.scrose];
    return YES;
  }
  return NO;
}

-(void)moveItemsWithDirection:(UISwipeGestureRecognizerDirection)theDirection
{
  moveResult.hasMoved = NO;
  moveResult.score = 0;
  switch (theDirection) {
    case UISwipeGestureRecognizerDirectionRight:
    {
      [self turnRightItems:&moveResult];
    }break;
    case UISwipeGestureRecognizerDirectionLeft:
    {
      [self turnLeftItems:&moveResult];
    }break;
    case UISwipeGestureRecognizerDirectionUp:
    {
      [self turnTopItems:&moveResult];
    }break;
    case UISwipeGestureRecognizerDirectionDown:
    {
      [self turnButtomItems:&moveResult];
    }break;
      
    default:
      break;
  }
  if (!moveResult.hasMoved && mItemListEmpty.count>0) {return;}
  
    // 刷新分数
  if (moveResult.score>0) {
    scoreNumberNow +=moveResult.score;
    if (scoreNumberTal<scoreNumberNow) {
      scoreNumberTal = scoreNumberNow;
      self.scoreTall.text = [NSString stringWithFormat:@"%d",scoreNumberTal];
    }
    self.scoreNow.text = [NSString stringWithFormat:@"%d",scoreNumberNow];
  }
  
    // 检查是否可以移动
  if (moveResult.hasMoved) {
    // create new one
    BOOL isCreate = [self createAndFillNewItem];
    if (!isCreate) {
      NSLog(@"----------- create new item error --------------");
    }else{
      [self recordNowDatas];
    }
  }else{
    if ([self checkCouldMoveNextItem]) {
        // 该方向没有移动,其他方向可以移动或者合并
      NSLog(@"---- move direction error ----");
    }else{
      NSLog(@"------- game over --------");
      [[[UIAlertView alloc] initWithTitle:nil message:@"游戏结束!\n提示:可以'上一步'悔退" delegate:nil cancelButtonTitle:@"确   定" otherButtonTitles:nil, nil] show];
    }
  }
    // log body
  [mUtils printBodyViews:mItemListAll rowNumber:mBodyTable.row];
}

// right
-(void)turnRightItems:(test2048MoveResult*)theResult
{
  for (int jt=0; jt<mBodyTable.col; jt++) {
      // 合并数据
    for (int it=mBodyTable.row-1; it>=0;it--) {
      if (it==0) {break;}
      Test2048ItemView *tempItem1 = mItemListAll[jt*mBodyTable.row+it];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = mItemListAll[jt*mBodyTable.row+kt];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      NSLog(@"--- right  \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*mBodyTable.row+it),it+1,jt+1,tempItem1,(jt*mBodyTable.row+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        theResult->score += tempItem1.mNumber;
        int tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[mUtils findItemShowNumber:tempNumber]
                    textColor:[mUtils findItemTextColor:tempNumber]
                      bgColor:[mUtils findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [mItemListEmpty addObject:tempItem2];
        it= index;
        theResult->hasMoved = YES;
      }else{
        it= index+1;
      }
    }
    
      // 右移数据块
    for (int it=mBodyTable.row-1; it>=0; it--) {
      Test2048ItemView *tempItem1 = mItemListAll[jt*mBodyTable.row+it];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = mItemListAll[jt*mBodyTable.row+kt];
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
      [mItemListEmpty removeObject:tempItem1];
      [mItemListEmpty addObject:tempItem2];
      theResult->hasMoved = YES;
    }
  }
}

  // left
-(void)turnLeftItems:(test2048MoveResult*)theResult
{
  for (int jt=0; jt<mBodyTable.col; jt++) {
      // 合并数据
    for (int it=0; it<mBodyTable.row;it++) {
      if (it== mBodyTable.row-1) {break;}
      Test2048ItemView *tempItem1 = mItemListAll[jt*mBodyTable.row+it];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<mBodyTable.row; kt++) {
        tempItem2 = mItemListAll[jt*mBodyTable.row+kt];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      NSLog(@"--- left  \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*mBodyTable.row+it),it+1,jt+1,tempItem1,(jt*mBodyTable.row+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        theResult->score += tempItem1.mNumber;
        int tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[mUtils findItemShowNumber:tempNumber]
                    textColor:[mUtils findItemTextColor:tempNumber]
                      bgColor:[mUtils findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [mItemListEmpty addObject:tempItem2];
        it= index;
        theResult->hasMoved = YES;
      }else{
        it=index-1;
      }
    }
    
      // 左移数据块
    for (int it=0; it<mBodyTable.row; it++) {
      Test2048ItemView *tempItem1 = mItemListAll[jt*mBodyTable.row+it];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<mBodyTable.row; kt++) {
        tempItem2 = mItemListAll[jt*mBodyTable.row+kt];
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
      [mItemListEmpty removeObject:tempItem1];
      [mItemListEmpty addObject:tempItem2];
      theResult->hasMoved = YES;
    }
  }
}

  // top
-(void)turnTopItems:(test2048MoveResult*)theResult
{
  for (int jt=0; jt<mBodyTable.row; jt++) {
      // 合并数据
    for (int it=0; it<mBodyTable.col;it++) {
      if (it== mBodyTable.col-1) {break;}
      Test2048ItemView *tempItem1 = mItemListAll[jt+it*mBodyTable.row];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<mBodyTable.col; kt++) {
        tempItem2 = mItemListAll[jt+kt*mBodyTable.row];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      
      NSLog(@"--- top   \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*mBodyTable.row+it),it+1,jt+1,tempItem1,(jt*mBodyTable.row+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        theResult->score += tempItem1.mNumber;
        int tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[mUtils findItemShowNumber:tempNumber]
                    textColor:[mUtils findItemTextColor:tempNumber]
                      bgColor:[mUtils findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [mItemListEmpty addObject:tempItem2];
        it= index;
        theResult->hasMoved = YES;
      }else{
        it=index-1;
      }
    }
    
      // 左移数据块
    for (int it=0; it<mBodyTable.col; it++) {
      Test2048ItemView *tempItem1 = mItemListAll[jt+it*mBodyTable.row];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it+1; kt<mBodyTable.col; kt++) {
        tempItem2 = mItemListAll[jt+kt*mBodyTable.row];
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
      [mItemListEmpty removeObject:tempItem1];
      [mItemListEmpty addObject:tempItem2];
      theResult->hasMoved = YES;
    }
  }
}

  // buttom
-(void)turnButtomItems:(test2048MoveResult*)theResult
{
  for (int jt=0; jt<mBodyTable.row; jt++) {
      // 合并数据
    for (int it=mBodyTable.col-1; it>=0;it--) {
      if (it==0) {break;}
      Test2048ItemView *tempItem1 = mItemListAll[jt+it*mBodyTable.row];
      if (tempItem1.mEmpty) {continue;}
      Test2048ItemView *tempItem2;
      int index = 0;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = mItemListAll[jt+kt*mBodyTable.row];
        if (!tempItem2.mEmpty) {
          index = kt;
          break;
        }
      }
      
      if (!tempItem2 || tempItem2.mEmpty) {
          // it 没有需要合并的数据,结束
        break;
      }
      
      NSLog(@"--- buttom  \n item1:[%d](%d,%d)[%@]  \n item2:[%d](%d,%d)[%@] \n--- ",(jt*mBodyTable.row+it),it+1,jt+1,tempItem1,(jt*mBodyTable.row+index),index+1,jt+1,tempItem2);
        // 判断是否需要合并数据
      if (tempItem1.mNumber == tempItem2.mNumber) {
        theResult->score += tempItem1.mNumber;
        int tempNumber = tempItem1.mNumber*2;
        [tempItem1 updateView:tempNumber
                   showNumber:[mUtils findItemShowNumber:tempNumber]
                    textColor:[mUtils findItemTextColor:tempNumber]
                      bgColor:[mUtils findItemBgColor:tempNumber]];
        [tempItem2 emptyView];
        [mItemListEmpty addObject:tempItem2];
        it= index;
        theResult->hasMoved = YES;
      }else{
        it=index+1;
      }
    }
    
      // 下移数据块
    for (int it=mBodyTable.col-1; it>=0; it--) {
      Test2048ItemView *tempItem1 = mItemListAll[jt+it*mBodyTable.row];
      if (!tempItem1.mEmpty) {continue;}
      
      Test2048ItemView *tempItem2;
      for (int kt=it-1; kt>=0; kt--) {
        tempItem2 = mItemListAll[jt+kt*mBodyTable.row];
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
      [mItemListEmpty removeObject:tempItem1];
      [mItemListEmpty addObject:tempItem2];
      theResult->hasMoved = YES;
    }
  }
}


@end



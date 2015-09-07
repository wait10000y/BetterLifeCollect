//
//  BetterLife
//
//  Created by shiliang.wang on 14-10-21.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "MainViewController.h"

#define app_cmd_exit @"cmd_exit"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) NSArray *mItemKeys;
@property (nonatomic) NSMutableDictionary *mItemDict;
@property (nonatomic) NSString *mCellIdentifier;
@end

@implementation MainViewController
{

}
@synthesize mTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
  _mItemDict = [NSMutableDictionary new];
  _mCellIdentifier = @"mTableViewCellIdentifier";
  self.title = deviceIsPad?@"测试列表(iPad)":@"测试列表(iPhone)";
  [self addTestItems];
  
//  [self testOthers];
  NSLog(@"---- timezone systemTimeZone: %@ ----",[NSTimeZone systemTimeZone]);
  NSLog(@"---- timezone localTimeZone: %@ ----",[NSTimeZone localTimeZone]);
  NSLog(@"---- timezone defaultTimeZone: %@ ----",[NSTimeZone defaultTimeZone]);
  
}

-(void)testOthers
{
  
  NSString *testStr = @"1234324235453";
  
  NSArray *tArr1 = [testStr componentsSeparatedByString:@"3"];
  NSArray *tArr2 = [testStr componentsSeparatedByString:@"0"];
  NSArray *tArr3 = [testStr componentsSeparatedByString:@"1234324235453"];
  NSLog(@"----str:[%@],arr1:%@, arr2:%@, arr3:%@ ----------",testStr,tArr1,tArr2,tArr3);
  
  // -----------------------------
  
  NSString *dfString = @"yyyy-MM-dd HH:mm:ss";
  NSDate *nowDate = [NSDate new];
  
  NSString *nowDateStr = [self getDateStringWithDate:nowDate formatString:dfString withTimeZone:nil];
  NSDate *nowDate2 = [self getDateWithDateString:nowDateStr formatString:dfString withTimeZone:nil];
  NSLog(@"------ nowDate:%@ , str:%@ , nowDate2:%@ -------",nowDate,nowDateStr,nowDate2);
  return;
  
  
  NSString *dateStr = @"2012-12-21 15:14:35";
  NSDate *date = [self getDateWithDateString:dateStr formatString:dfString withTimeZone:nil];
  NSLog(@"------ str:%@ , date:%@ -------",dateStr,date);
  
  NSTimeZone *timezone = [NSTimeZone localTimeZone];
  NSLog(@"---- timezone: %@ ----",timezone);
  NSLog(@"------ timezone- name:%@,abbreviation:%@,secondsFromGMT:%ld, -------",timezone.name
        ,[timezone abbreviation]
        ,[timezone secondsFromGMT]
        );
  
  NSLog(@"---- timezone systemTimeZone: %@ ----",[NSTimeZone systemTimeZone]);
  NSLog(@"---- timezone localTimeZone: %@ ----",[NSTimeZone localTimeZone]);
  NSLog(@"---- timezone defaultTimeZone: %@ ----",[NSTimeZone defaultTimeZone]);
  NSLog(@"---- timezone timeZoneDataVersion: %@ ----",[NSTimeZone timeZoneDataVersion]);
  
  NSLog(@"---- timezone knownTimeZoneNames: %@ ----",[NSTimeZone knownTimeZoneNames]);
  NSLog(@"---- timezone abbreviationDictionary: %@ ----",[NSTimeZone abbreviationDictionary]);
  
  
}

-(void)addTestItems
{
  
  NSDictionary *testItems = @{
//                              @"测试雪花飘舞效果"      :@"TestSnowFallViewController",
//                              @"测试输入框震动效果"    :@"TestTextFieldViewController",
//                              @"testString"         :@"TestStringViewController",
//                              @"简易烟花"            :@"TestFileWorkViewController",
//                              @"测试MKNetworkKit"      :@"TestDownload2ViewController",
//                              @"testAsyncSocket" :@"TestAsyncSocketViewController",
//                              @"随机数测试1"            :@"PLifeMainViewController",
//                              @"随机数测试2"              :@"DCBallMainViewController",
//                              @"testImageView"      :@"TestImageViewController",
//                              @"2048"               :@"Test2048ViewController",
//                              @"简单涂鸦":@"TestPaletteViewController",
                              @"字体列表":@"TestFontListViewController",
                              @"---关闭程序---":app_cmd_exit
                              };
  
  [_mItemDict setDictionary:testItems];
  
 _mItemKeys = [_mItemDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
   return [obj1 compare:obj2];
}];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ====== UITableView delegate ======

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _mItemKeys.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_mCellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_mCellIdentifier];
  }
  cell.textLabel.text = _mItemKeys[indexPath.row];
 
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 48.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self createNextViewControllerWithName:_mItemKeys[indexPath.row]];
}

-(void)createNextViewControllerWithName:(NSString *)theName
{
  NSString *theValue = _mItemDict[theName];
  if (theValue) {
    if ([app_cmd_exit isEqualToString:theValue]) {
      exit(0);
      return;
    }
    Class tempClass = NSClassFromString(theValue);
    BOOL right = [tempClass isSubclassOfClass:[BaseDefineViewController class]];
    if (right) {
      BaseDefineViewController *tempVC = [[tempClass alloc] initWithNibName:theValue bundle:nil];
      tempVC.title = theName;
      [self.navigationController pushViewController:tempVC animated:YES];
    }
  }
}






@end

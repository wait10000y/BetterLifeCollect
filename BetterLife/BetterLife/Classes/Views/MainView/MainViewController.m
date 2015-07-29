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

@end

@implementation MainViewController
{
  NSMutableDictionary *mItemDict; // key:showName,value:className;
  NSString *mCellIdentifier;
}
@synthesize mTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
  mItemDict = [NSMutableDictionary new];
  mCellIdentifier = @"mTableViewCellIdentifier";
  self.title = deviceIsPad?@"测试列表(iPad)":@"测试列表(iPhone)";
  [self addTestItems];
  
  NSString *testStr = @"1234324235453";
  
  NSArray *tArr1 = [testStr componentsSeparatedByString:@"3"];
    NSArray *tArr2 = [testStr componentsSeparatedByString:@"0"];
    NSArray *tArr3 = [testStr componentsSeparatedByString:@"1234324235453"];
  NSLog(@"----str:[%@],arr1:%@, arr2:%@, arr3:%@ ----------",testStr,tArr1,tArr2,tArr3);
  
  
  
}

-(void)addTestItems
{
  
  NSDictionary *testItems = @{
                              @"测试雪花飘舞效果"      :@"TestSnowFallViewController",
                              @"测试输入框震动效果"    :@"TestTextFieldViewController",
                              @"testString"         :@"TestStringViewController",
                              @"testImageView"      :@"TestImageViewController",
                              @"2048"               :@"Test2048ViewController",
                              @"简易烟花"            :@"TestFileWorkViewController",
                              @"双色球"              :@"DCBallMainViewController",
                              @"随机数测试"            :@"PLifeMainViewController",
                              @"测试MKNetworkKit"      :@"TestDownload2ViewController",
                              @"testAsyncSocket" :@"TestAsyncSocketViewController",
                              @"简单涂鸦":@"TestPaletteViewController",
                              @"字体列表":@"TestFontListViewController",
                              @"---关闭程序---":app_cmd_exit
                              };
  
  [mItemDict setDictionary:testItems];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ====== UITableView delegate ======

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return mItemDict.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mCellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mCellIdentifier];
  }
  cell.textLabel.text = mItemDict.allKeys[indexPath.row];
 
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 48.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self createNextViewControllerWithName:mItemDict.allKeys[indexPath.row]];
}

-(void)createNextViewControllerWithName:(NSString *)theName
{
  NSString *theValue = mItemDict[theName];
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

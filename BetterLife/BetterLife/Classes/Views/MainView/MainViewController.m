//
//  BetterLife
//
//  Created by shiliang.wang on 14-10-21.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "MainViewController.h"

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
}

-(void)addTestItems
{
  
  NSDictionary *testItems = @{
//                              @"测试雪花飘舞效果"      :@"TestSnowFallViewController",
//                              @"测试输入框震动效果"    :@"TestTextFieldViewController",
//                              @"testString"         :@"TestStringViewController",
//                              @"testImageView"      :@"TestImageViewController",
//                              @"2048"               :@"Test2048ViewController",
//                              @"简易烟花"            :@"TestFileWorkViewController",
//                              @"双色球"              :@"DCBallMainViewController",
//                              @"64金钱卦"            :@"PLifeMainViewController",
//                              @"测试MKNetworkKit"      :@"TestDownload2ViewController",
                              @"testAsyncSocket" :@"TestAsyncSocketViewController",
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

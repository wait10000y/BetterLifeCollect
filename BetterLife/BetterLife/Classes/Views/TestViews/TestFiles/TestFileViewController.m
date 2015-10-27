//
//  TestFileViewController.m
//  BetterLife
//
//  Created by wsliang on 15/10/10.
//  Copyright © 2015年 wsliang. All rights reserved.
//

#import "TestFileViewController.h"

#import "User.h"

@interface TestFileViewController ()

@end

@implementation TestFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  [self testKeyedArchiver];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// 测试 keyedArchiver 归档的功能
-(void)testKeyedArchiver
{
  User *f1 = [User new];f1.nickname = @"friends1";f1.age = 20;
  User *f2 = [User new];f2.nickname = @"friends2";f2.age = 22;
  
  User *c1 = [User new];c1.nickname = @"mingming";c1.age = 8;
  User *c2 = [User new];c2.nickname = @"lili";c2.age = 6;
  
  User *user = [[User alloc] init];
  user.age = 19;
  user.nickname = @"Durban";
  user.email = @"896360979@qq.com";
  user.isAdmin = YES;
  user.children = @[c1,c2];
  user.friends = @{f1.nickname:f1,f2.nickname:f2};
  //  srandom((unsigned int)time(NULL));
  //归档处理
  NSString *homeDir = NSHomeDirectory();
  NSString *filePath = [homeDir stringByAppendingPathComponent:@"user.info"];
  
  BOOL success = [NSKeyedArchiver archiveRootObject:user
                                             toFile:filePath];
  if(success)
  {
    NSString *showStr = @"--- sucess create archiver ---";
//    [self appendShowString:showStr];
    NSLog(showStr);
  }
  
  //解归档处理
  NSString *homeDirectory = NSHomeDirectory();
  NSString *dataFilePath = [homeDirectory stringByAppendingPathComponent:@"user.info"];
  User *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:dataFilePath];
  NSString *readStr = [userInfo description];
  NSString *showStr = @"--- sucess read archiver : ---";
  
//  [self appendShowString:showStr];
//  [self appendShowString:readStr];
  
  NSLog(showStr);
  NSLog(readStr);
  
}











@end

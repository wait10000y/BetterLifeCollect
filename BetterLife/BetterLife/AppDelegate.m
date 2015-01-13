//
//  AppDelegate.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-21.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "TestTextFieldViewController.h"

#import "DDCLLogger.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "DDFileLogger.h"
#import "SystemInfoObject.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

#import "DDLogCommon.h"
static const int ddLogLevel = LOGLEVEL_NORMAL;

@implementation AppDelegate
{
  Reachability *reachability;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
//  TestTextFieldViewController *testVC = [[TestTextFieldViewController alloc] initWithNibName:NSStringFromClass([TestTextFieldViewController class]) bundle:nil];
  
  MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
  UINavigationController *baseViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//  baseViewController.navigationBarHidden = YES;
  self.window.rootViewController = baseViewController;
  [self.window makeKeyAndVisible];
  [self ddLogInit];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  DDLogInfo(@"WillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  DDLogInfo(@"EnterBackground support mutitask:%d",[UIDevice currentDevice].multitaskingSupported);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  DDLogInfo(@"EnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  DDLogInfo(@"DidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  DDLogInfo(@"WillTerminate");
}

-(void)startReachabilityNotifier
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityChanged:)
                                               name:kReachabilityChangedNotification
                                             object:nil];
//  reachability = [Reachability reachabilityWithHostname:@"wangshiliang.com.cn"];
  reachability = [Reachability reachabilityForInternetConnection];
//  reachability = [Reachability reachabilityForLocalWiFi];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [reachability startNotifier];
  });
}

-(void) reachabilityChanged:(NSNotification*) notification
{
  Reachability *tempReachability = notification.object;
  if([tempReachability currentReachabilityStatus] == ReachableViaWiFi)
  {
    DDLogWarn(@"Server is reachable via Wifi");
  }
  else if([tempReachability currentReachabilityStatus] == ReachableViaWWAN)
  {
    DDLogWarn(@"Server is reachable only via cellular data");
  }
  else if([tempReachability currentReachabilityStatus] == NotReachable)
  {
    DDLogWarn(@"Server is not reachable");
  }
  [MBProgressHUD showGlobViewWithType:MBProgressHUDMsg_warn withDelegate:nil animated:YES];
  [MBProgressHUD updateGlobViewWithType:MBProgressHUDMsg_warn withTips:@"网络改变" withMessage:nil];
  [MBProgressHUD hideGlobView:YES withDelay:4];
}

-(void)ddLogInit
{
  [SystemInfoObject setUncaughtExceptionHandler];
  
  DDLogFileFormatterDefault *logFormatter = [DDLogFileFormatterDefault new];
#ifdef LOG_ON_OUT_CONSOLE
  DDTTYLogger *ttyl = [DDTTYLogger sharedInstance];
  ttyl.logFormatter = logFormatter;
  [DDLog addLogger:ttyl]; // 控制台 输出
#endif
  
#ifdef LOG_ON_OUT_CONSOLE2
  DDCLLogger *ttyl = [DDCLLogger sharedInstance];
    //  ttyl.logFormatter = logFormatter;
  [DDLog addLogger:ttyl]; // 控制台 输出
#endif
  
#ifdef LOG_ON_OUT_SYSTEM
  DDASLLogger *asll = [DDASLLogger sharedInstance];
  asll.logFormatter = logFormatter;
  [DDLog addLogger:asll]; // 系统日志 输出
#endif
  
#ifdef LOG_ON_OUT_FILE
  DDFileLogger *fileLogger = [[DDFileLogger alloc]  init];
  fileLogger.rollingFrequency = 60 * 60 * 24;   // 24 hour rolling
  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
  [DDLog addLogger:fileLogger];
    //  NSLog(@"----filePath:[%@],files:[%@]-----",[fileLogger.logFileManager logsDirectory],[fileLogger.logFileManager sortedLogFilePaths]);
    //  [TDL_GlobDataObject shareObject].normalData = fileLogger;
#endif
  logFormatter = nil;
  
  DDLogInfo(@"%@",[SystemInfoObject getAppInfo]);
}

@end

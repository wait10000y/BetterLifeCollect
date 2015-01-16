//
//  SIDLownloadTestViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/9.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "SIDLownloadTestViewController.h"

NSString *urlOne = @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.1.0.dmg";
NSString *urlTwo = @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V1.4.1.dmg";

@interface SIDLownloadTestViewController ()
@property (strong, nonatomic) SIDownloadManager *siDownloadManager;

@end

@implementation SIDLownloadTestViewController

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
  self.title = @"断点下载测试";
  
  _siDownloadManager = [SIDownloadManager sharedSIDownloadManager];
  
  _labelStatusOne.text = @"未下载";
  _labelStatusTwo.text = @"未下载";
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  _siDownloadManager.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [_siDownloadManager setDelegate:nil];
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionShowOthers:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button action
- (IBAction)downloadOneAction:(id)sender {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = [paths objectAtIndex:0];
  NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"2.1.dmg"];
  _labelStatusOne.text = @"下载中";
  [_siDownloadManager addDownloadFileTaskInQueue:urlOne
                                      toFilePath:downloadPath
                                breakpointResume:YES
                                     rewriteFile:NO];
}

- (IBAction)pauseOneAction:(id)sender {
  _labelStatusOne.text = @"暂停";
  [_siDownloadManager cancelDownloadFileTaskInQueue:urlOne];
}

- (IBAction)deleteOneAction:(id)sender {
  _labelStatusOne.text = @"删除缓存";
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = [paths objectAtIndex:0];
  NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"2.1.dmg"];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:downloadPath]) {
    [fileManager removeItemAtPath:downloadPath error:nil];
  }
}

- (IBAction)downloadTwoAction:(id)sender {
  _labelStatusTwo.text = @"下载中";
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = [paths objectAtIndex:0];
  NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"1.4.dmg"];
  
  [_siDownloadManager addDownloadFileTaskInQueue:urlTwo
                                      toFilePath:downloadPath
                                breakpointResume:YES
                                     rewriteFile:NO];
}

- (IBAction)pauseTwoAction:(id)sender {
  _labelStatusTwo.text = @"暂停";
  [_siDownloadManager cancelDownloadFileTaskInQueue:urlTwo];
}

- (IBAction)deleteTwoAction:(id)sender {
  _labelStatusTwo.text = @"删除缓存";
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = [paths objectAtIndex:0];
  NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"1.4.dmg"];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:downloadPath]) {
    [fileManager removeItemAtPath:downloadPath error:nil];
  }
}

#pragma mark - SIDownloadManagerDelegate
- (void)downloadManager:(SIDownloadManager *)siDownloadManager
          withOperation:(SIBreakpointsDownload *)paramOperation
         changeProgress:(double)paramProgress
{
  if ([urlOne isEqualToString:paramOperation.url]) {
    _progressViewOne.progress = paramProgress;
    [_labelOne setText:[NSString stringWithFormat:@"%.1f%%", paramProgress * 100]];
  }else if([urlTwo isEqualToString:paramOperation.url]){
    _progressViewTwo.progress = paramProgress;
    [_labelTwo setText:[NSString stringWithFormat:@"%.1f%%", paramProgress * 100]];
  }
}

- (void)downloadManagerDidComplete:(SIDownloadManager *)siDownloadManager
                     withOperation:(SIBreakpointsDownload *)paramOperation
{
  NSLog(@"download DidComplete for url:%@",paramOperation.url);
  if ([paramOperation.url isEqualToString:urlOne]) {
    NSLog(@"done one");
  }else if([paramOperation.url isEqualToString:urlTwo]){
    NSLog(@"done two");
  }
  
}

- (void)downloadManagerError:(SIDownloadManager *)siDownloadManager
                     withURL:(NSString *)paramURL
                   withError:(NSError *)paramError
{
  NSLog(@"DownloadErr for url:%@ error:%@",paramURL,paramError);
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                      message:@"请检查你的网络连接状态！"
                                                     delegate:nil
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确认",nil];
  [alertView show];
  
}

- (void)downloadManagerDownloadDone:(SIDownloadManager *)siDownloadmanager
                            withURL:(NSString *)paramURL
{
  NSLog(@"DownloadDone for url:%@",paramURL);
}

- (void)downloadManagerPauseTask:(SIDownloadManager *)siDownloadManager
                         withURL:(NSString *)paramURL
{
  NSLog(@"DownloadPauseTask for url:%@",paramURL);
}

- (void)downloadManagerDownloadExist:(SIDownloadManager *)siDwonloadManager
                             withURL:(NSString *)paramURL
{
  NSLog(@"DownloadExist for url:%@",paramURL);
}

@end

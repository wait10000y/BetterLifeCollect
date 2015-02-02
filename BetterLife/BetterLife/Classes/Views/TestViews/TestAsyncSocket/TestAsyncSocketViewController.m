//
//  TestAsyncSocketViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/28.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestAsyncSocketViewController.h"

#import "GCDAsyncSocket.h"


@interface TestAsyncSocketViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic) GCDAsyncSocket *asyncSocket;

@end

@implementation TestAsyncSocketViewController

@synthesize asyncSocket;

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(IBAction)actionDownloadFile:(UIButton*)sender
{
  if ([self createDownloaFile]) {
    NSLog(@"---- start download ok ----");
  }
}


-(BOOL)createDownloaFile
{
  asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
  NSError *error;
  BOOL result = [asyncSocket connectToHost:@"www.baidu.com" onPort:80 viaInterface:nil withTimeout:12 error:&error];
  if (!result || error) {
    NSLog(@"---------result:%d,error:%@ -------------",result,error);
    return NO;
  }
  [asyncSocket readDataWithTimeout:10 tag:100];
//  [asSocket writeData:nil withTimeout:10 tag:2];
//  [asSocket readDataToData:nil withTimeout:10 tag:1];
  
//  [asSocket disconnect];
  
  return YES;
}

#pragma  mark ------ GCDAsyncSocketDelegate ------

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
  NSLog(@"--- socket didAcceptNewSocket ---");
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
  NSLog(@"--- socket didConnectToHost %@:%u ---",host,port);
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
  NSLog(@"--- socket socketDidDisconnect error:%@ ---",err);
  asyncSocket = nil;
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
  NSLog(@"--- socket didReadData:%ld, tag:%ld ---",(unsigned long)data.length,tag);
  [sock readDataWithTimeout:10 tag:tag++];
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
  NSLog(@"--- socket didWriteDataWithTag:%ld ---",tag);
//  [sock writeData:nil withTimeout:10 tag:tag++];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
   NSLog(@"--- socket socketDidSecure ---");
}




@end

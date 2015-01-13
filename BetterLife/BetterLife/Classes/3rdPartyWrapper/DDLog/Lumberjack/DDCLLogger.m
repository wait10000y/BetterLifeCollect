//
//  DDCLLogger.m
//  testDDLog
//
//  Created by shiliang.wang on 14-7-28.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "DDCLLogger.h"

#import <unistd.h>
#import <sys/uio.h>

@implementation DDCLLogger

static DDCLLogger *sharedInstance;

+ (instancetype)sharedInstance
{
  static dispatch_once_t DDTTYLoggerOnceToken;
  dispatch_once(&DDTTYLoggerOnceToken, ^{
    sharedInstance = [[[self class] alloc] init];
  });
  return sharedInstance;
}

- (id)init
{
  if (sharedInstance != nil)
  {
    return nil;
  }
  
  if ((self = [super init]))
  {
    
  }
  return self;
}

- (void)logMessage:(DDLogMessage *)logMessage
{
    // TODO user system NSLog
  NSString *msg = logMessage->logMsg;
  NSString *fileName = [NSString stringWithFormat:@"%s",logMessage->file];
  NSRange range = [fileName rangeOfString:@"/" options:NSBackwardsSearch];
  if (range.length>0) {fileName = [fileName substringFromIndex:range.location+1];}
  
  NSLog(@"[%@][%d:%@][%@] %@",logMessage.threadID,logMessage->lineNumber,logMessage.fileName,logMessage.methodName,msg);return;
  
  /*
   struct iovec v[2];
   v[0].iov_base = (char *)[msg cStringUsingEncoding:NSUTF8StringEncoding];
   v[0].iov_len = [msg lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
   
   v[1].iov_base = "\n";
   v[1].iov_len = 1;
   
   writev(STDERR_FILENO, v, 2);
   */
}

- (NSString *)loggerName
{
  return @"cocoa.lumberjack.clLogger";
}

@end

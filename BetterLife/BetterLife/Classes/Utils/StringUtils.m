//
//  StringUtils.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/21.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "StringUtils.h"

#include <netdb.h>
#include <sys/socket.h>
#import <arpa/inet.h>


@implementation StringUtils


-(void)showQueueMessage:(NSString*)message
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    NSLog(@" >> %@", message);
    
//    self.receiveTextView.text = message;
//    self.connectButton.enabled = YES;
//    [self.networkActivityView stopAnimating];
  }];
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
  NSString *  result;
  CFUUIDRef   uuid;
  NSString *  uuidStr;
  
  uuid = CFUUIDCreate(NULL);
  assert(uuid != NULL);
  
  uuidStr = CFBridgingRelease( CFUUIDCreateString(NULL, uuid) );
  
  result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
  assert(result != nil);
  
  CFRelease(uuid);
  
  return result;
}

- (NSURL *)smartURLForString:(NSString *)str
{
  NSURL *result = nil;
  if (str.length) {
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedStr.length) {
      schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
      
      if (schemeMarkerRange.location == NSNotFound) {
        result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
      } else {
        scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
        assert(scheme != nil);
        
        if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
            || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
          result = [NSURL URLWithString:trimmedStr];
        } else {
            // It looks like this is some unsupported URL scheme.
        }
      }
    }
  }

  return result;
}

-(NSURL*)resourseFile
{
//  NSProcessInfo *proc = [NSProcessInfo processInfo];
//  NSTimeInterval time = proc.systemUptime;
//  long memory = proc.physicalMemory;
  
    // NSFormatter
    // NSNumberFormatter、NSDateFormatter以及NSByteCountFormatter。
    // NSCache
  
  
  NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:@"Info" withExtension:@"html"];
  return infoFileURL;
}


- (NSString *) getIPForHost: (NSString *)theHost
{
    struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
    struct in_addr **list = (struct in_addr **)host->h_addr_list; // ip 地址列表
    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}

// 返回该域名的所有ip地址
-(NSArray*)getIPsForHost:(NSString*)theHost
{
    struct hostent *hptr = gethostbyname([theHost UTF8String]);
    if (!hptr) {herror("resolv"); return NULL; }
    char **pptr = hptr->h_addr_list;
    char str[32];
    NSMutableArray *mArr = [NSMutableArray new];
    
    for(;*pptr!=NULL;pptr++)
        [mArr addObject:[NSString stringWithFormat:@"%s",inet_ntop(hptr->h_addrtype, *pptr, str, sizeof(str))]];
    return [NSArray arrayWithArray:mArr];
}



/*
 
 // define
 char                _networkOperationCountDummy;
 
 // addObserver
 [[NetworkManager sharedInstance] addObserver:self forKeyPath:@"networkOperationCount" options:NSKeyValueObservingOptionInitial context:&self->_networkOperationCountDummy];
 
 
 // implement
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
 {
 if (context == &self->_networkOperationCountDummy) {
 [UIApplication sharedApplication].networkActivityIndicatorVisible = ([NetworkManager sharedInstance].networkOperationCount != 0);
 } else {
 [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
 }
 }
 */
@end

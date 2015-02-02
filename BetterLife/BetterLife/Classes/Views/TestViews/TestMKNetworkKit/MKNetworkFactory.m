//
//  MKNetworkFactory.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/20.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "MKNetworkFactory.h"

@implementation MKNetworkFactory
{
  NSMutableDictionary *mNetworkDict;
  
  
}
@synthesize connections = mNetworkDict;

+(instancetype)factory
{
  static dispatch_once_t factoryTorken;
  static id tempFactory;
  dispatch_once(&factoryTorken, ^{
    tempFactory = [[MKNetworkFactory alloc] init];
  });
  return tempFactory;
}



-(MKNetworkOperation *)getDataWithUrl:(NSURL*)theUrl withComplete:(MKNetworkCompleteBlock)theComplete
{
  MKNetworkEngine *tempNetwork = [self createNetworkEngine:theUrl.host portNumber:[theUrl.port intValue]];
  MKNetworkOperation *tempOper = [tempNetwork operationWithURLString:theUrl.absoluteString];
  
  [tempOper onNotModified:^{
    theComplete(NO,nil,[NSError errorWithDomain:@"304 error" code:304 userInfo:nil]);
  }];
  
  [tempOper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    theComplete(YES,[completedOperation responseData],nil);
  } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    theComplete(NO,[completedOperation responseData],error);
  }];
  [tempNetwork enqueueOperation:tempOper];
  return tempOper;
}


  // -------------- utils -------------

-(MKNetworkEngine*)createNetworkEngine:(NSString*)theHost portNumber:(int)thePort
{
  MKNetworkEngine *tempEngine = [[MKNetworkEngine alloc] initWithHostName:theHost portNumber:thePort apiPath:nil customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
  [mNetworkDict setObject:tempEngine forKey:[NSString uniqueString]];
  return tempEngine;
}

@end

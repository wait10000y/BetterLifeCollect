//
//  MKNetworkFactory.h
//  BetterLife
//
//  Created by shiliang.wang on 15/1/20.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

typedef void (^MKNetworkCompleteBlock) (BOOL operRes, id resData , NSError *error);

@interface MKNetworkFactory : NSObject

@property (nonatomic,readonly) NSDictionary *connections;

+(instancetype)factory;

-(MKNetworkOperation *)getDataWithUrl:(NSURL*)theUrl withComplete:(MKNetworkCompleteBlock)theComplete;




@end

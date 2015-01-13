//
//  StanObject.h
//  testAVSpeech
//
//  Created by shiliang.wang on 14-8-1.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemInfoObject : NSObject

+(SystemInfoObject*)shareObject;

+ (NSString *) getDocumentsDirectory;
+ (NSString *) getAppInfo;

+ (float)cpu_usage;
+ (NSString *) getMacaddress;
+ (NSArray *) backtrace;

+ (void)setUncaughtExceptionHandler;

- (NSUInteger) maxSocketBufferSize;

@end

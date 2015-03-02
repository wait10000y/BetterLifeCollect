//
//  StringUtils.h
//  BetterLife
//
//  Created by shiliang.wang on 15/1/21.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject



-(void)showQueueMessage:(NSString*)message;

  // 在缓存文件夹中创建一个随机的文件夹路径
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;

- (NSURL *)smartURLForString:(NSString *)str;


@end

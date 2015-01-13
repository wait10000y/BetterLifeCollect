//
//  AudioPlayUtil.h
//  IECS
//
//  Created by shiliang.wang on 14-11-11.
//  Copyright (c) 2014年 XOR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayUtil : NSObject



+(void)playVibrate;
+(void)playMessageSound;

+(void)playCalllingRing;
+(void)stopCalllingRing;

+(void)playSoundWithResource:(NSString*)theName ofType:(NSString*)theType;

@end

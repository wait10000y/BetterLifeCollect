//
//  AudioPlayUtil.h
//  IECS
//
//  Created by shiliang.wang on 14-11-11.
//  Copyright (c) 2014年 XOR. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  这个播放声音功能 是播放 SystemSoundID 的声音
 *  只支持 30s内的声音
 */
@interface SimpleSoundPlayUtil : NSObject



+(void)playVibrate;
+(void)playMessageSound;

+(void)playCalllingRing;
+(void)stopCalllingRing;

+(void)playSoundWithResource:(NSString*)theName ofType:(NSString*)theType;

@end

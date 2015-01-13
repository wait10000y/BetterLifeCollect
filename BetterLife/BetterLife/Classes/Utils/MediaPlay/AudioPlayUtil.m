//
//  AudioPlayUtil.m
//  IECS
//
//  Created by shiliang.wang on 14-11-11.
//  Copyright (c) 2014年 XOR. All rights reserved.
//

#import "AudioPlayUtil.h"
#import <AVFoundation/AVFoundation.h>


@implementation AudioPlayUtil

static SystemSoundID callingSoundId = 0;
static bool isStopCallingRing = NO;

+(void)playVibrate
{
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+(SystemSoundID)getSoundIDForResource:(NSString*)theName ofType:(NSString*)theType withDefaultSoundID:(SystemSoundID)theDefault
{
  SystemSoundID tempSId;
  NSURL *tempUrl = [[NSBundle mainBundle] URLForResource: theName withExtension: theType];  // 获取自定义的声音
  if (tempUrl) {
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)tempUrl,&tempSId);
    if (error == kAudioServicesNoError) {//获取的声音的时候，出现错误
      return tempSId;
    }
  }
  return theDefault;
}

+(void)playMessageSound
{
  SystemSoundID soundId = [self getSoundIDForResource:@"smsSound" ofType:@"caf" withDefaultSoundID:1307];
  AudioServicesPlaySystemSound(soundId);
}

+(void)playCalllingRing{
//  NSURL *tempUrl = [NSURL fileURLWithPath:[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:@"sms-received1" ofType:@"caf"]];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
  callingSoundId = [self getSoundIDForResource:@"callSound" ofType:@"m4r" withDefaultSoundID:1151];
  AudioServicesAddSystemSoundCompletion(callingSoundId,NULL, NULL,playRingFinishedRepeatCallback,NULL);
  isStopCallingRing = NO;
  AudioServicesPlaySystemSound(callingSoundId);
}

+(void)stopCalllingRing{
  isStopCallingRing = YES;
  AudioServicesDisposeSystemSoundID(callingSoundId);
}


+(void)playSoundWithResource:(NSString*)theName ofType:(NSString*)theType
{
  SystemSoundID system_sound_id = [self getSoundIDForResource:theName ofType:theType withDefaultSoundID:0];
  if (system_sound_id != 0) {
      // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(
                                          system_sound_id,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          playRingFinishedStopCallback, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
      // Play the System Sound
    AudioServicesPlaySystemSound(system_sound_id);
  }
}


#pragma mark --- callback ---
static void playRingFinishedRepeatCallback(SystemSoundID soundID,void* user_data){
    // repeat
  if (!isStopCallingRing) {
    AudioServicesPlaySystemSound(soundID);
  }
}

static void playRingFinishedStopCallback(SystemSoundID soundID,void* user_data){
  AudioServicesDisposeSystemSoundID(soundID);
}


@end

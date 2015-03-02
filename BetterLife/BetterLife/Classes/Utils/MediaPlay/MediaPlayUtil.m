//
//  MediaPlayUtil.m
//  BetterLife
//
//  Created by shiliang.wang on 15/2/27.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "MediaPlayUtil.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation MediaPlayUtil
{
  MPMoviePlayerController *mMPPlayer;
  __weak UIViewController *mViewController;
  MediaPlayCallbackBlock mABlock;
  MediaPlayCallbackBlock mVBlock;
}

+(id)shareObject
{
  static MediaPlayUtil* mediaPlayer;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mediaPlayer = [[MediaPlayUtil alloc] init];
  });
  return mediaPlayer;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
      if (mMPPlayer) {
        [mMPPlayer stop];
        mMPPlayer = nil;
      }
    }];
  }
  return self;
}

-(void)stopMediaPlay
{
  if (mMPPlayer) {
    [mMPPlayer stop];
    mMPPlayer = nil;
    mABlock = nil;
  }
  if (mViewController) {
    [mViewController dismissMoviePlayerViewControllerAnimated];
    mViewController = nil;
    mVBlock = nil;
  }
}

  // notification called
-(void)playerDidFinishPlay
{
  [self removePlayNotification];
  if (mABlock) {
    mABlock(YES,nil);
  }
  if (mVBlock) {
    mVBlock(YES,nil);
  }
  [self stopMediaPlay];
}

-(void)regPlayNotification:(id)theSender
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:theSender];
}

-(void)removePlayNotification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)playAudioWithUrl:(NSURL*)theUrl withComplete:(MediaPlayCallbackBlock)theBlock
{
  [self stopMediaPlay];
  mABlock = theBlock;
  mMPPlayer = [[MPMoviePlayerController alloc] initWithContentURL:theUrl];
  [self regPlayNotification:mMPPlayer];
  [mMPPlayer play];
}

-(void)playVideoWithUrl:(NSURL*)theUrl withController:(UIViewController*)theController withComplete:(MediaPlayCallbackBlock)theBlock
{
  [self stopMediaPlay];
  mVBlock = theBlock;
  mViewController = theController;
  MPMoviePlayerViewController *mpViewPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:theUrl];
  [mViewController presentMoviePlayerViewControllerAnimated:mpViewPlayer];
}

-(void)stopAudioPlay
{
  if (mMPPlayer) {
    [mMPPlayer stop];
    mMPPlayer = nil;
    mABlock = nil;
  }
}

-(void)stopVideoPlay
{
  if (mViewController) {
    [mViewController dismissMoviePlayerViewControllerAnimated];
    mViewController = nil;
    mVBlock = nil;
  }
}

-(NSInteger)playImages:(NSArray*)theImages withDuration:(float)theDuration showView:(UIView*)theShowView
{
  if ([theShowView isKindOfClass:[UIImageView class]]) {
    UIImageView *imageView = (UIImageView*)theShowView;
    imageView.animationImages = theImages;
    imageView.animationDuration = theDuration;
    [imageView startAnimating];
  }else{
    
    
  }
  return 111;
}

-(void)stopImagesPlayWithID:(NSInteger)theId
{
  
}

@end

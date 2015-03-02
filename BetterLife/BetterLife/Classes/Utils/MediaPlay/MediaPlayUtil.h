//
//  MediaPlayUtil.h
//  BetterLife
//
//  Created by shiliang.wang on 15/2/27.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^MediaPlayCallbackBlock) (int status,NSError *error); // error 如果出错 error有值


@interface MediaPlayUtil : NSObject

@property (readonly) BOOL playing; // playing stoped

+(id)shareObject;

-(void)playAudioWithUrl:(NSURL*)theUrl withComplete:(MediaPlayCallbackBlock)theBlock;

-(void)playVideoWithUrl:(NSURL*)theUrl withController:( UIViewController*)theController withComplete:(MediaPlayCallbackBlock)theBlock;

-(void)stopAudioPlay;
-(void)stopVideoPlay;

/*!
 *  播放 一组图片
 *
 *  @param theImages   图片对象 数组
 *  @param theShowView 图像显示的view
 *  @param return 返回 当前view play的标记
 */
-(NSInteger)playImages:(NSArray*)theImages withTimeintval:(float)theTime showView:(UIView*)theShowView;

-(void)stopImagesPlayWithID:(NSInteger)theId;

@end

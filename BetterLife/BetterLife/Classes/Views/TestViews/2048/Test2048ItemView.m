//
//  Test2048ItemView.m
//  BetterLife
//
//  Created by shiliang.wang on 14/12/22.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "Test2048ItemView.h"
#import "Test2048Utils.h"

#define easyoutAnimate 1


@implementation Test2048ItemView
{
  UIColor *bgColorDefault;
  UIColor *textColorDefault;
  
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self createItemView];
    }
    return self;
}

-(void)createItemView
{
  self.mEmpty = YES;
  self.mUseAnimotin = YES;
  bgColorDefault = [[Test2048Utils sharedObject] findBodyItemBgColor];
  textColorDefault = [[Test2048Utils sharedObject] findItemTextColor:2];
  self.textColor = textColorDefault;
  self.backgroundColor = bgColorDefault;
  self.textAlignment = NSTextAlignmentCenter;
  
//  self.layer.backgroundColor = bgColorDefault.CGColor;
  self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
  self.layer.cornerRadius = 4;
  self.layer.masksToBounds = YES;
  self.layer.borderWidth = 1;
  self.layer.borderColor = [UIColor lightGrayColor].CGColor;
  
}

-(void)setEmptyTextColor:(UIColor *)theTextColor bgColor:(UIColor *)theBgColor
{
  textColorDefault = theTextColor?:textColorDefault;
  bgColorDefault = theBgColor?:bgColorDefault;
  
  self.textColor = textColorDefault;
  self.layer.backgroundColor = bgColorDefault.CGColor;
}

-(void)emptyView
{
  if (_mEmpty) {return;}
  _mEmpty = YES;
  _mNumber = 0;
  _mShowNumber = nil;
  _mTextColor = nil;
  _mBgColor = nil;
  if (self.mUseAnimotin) {
#ifdef easyoutAnimate
    float tempAlpha = self.alpha;
    [UIView animateWithDuration:itemViewAnimateDuration animations:^{
      self.alpha = 0;
      self.text = nil;
      self.textColor = textColorDefault;
      self.backgroundColor = bgColorDefault;
    } completion:^(BOOL finished) {
      self.alpha = tempAlpha;
    }];
#else
    CGRect tempFrame = self.frame;
    [UIView animateWithDuration:itemViewAnimateDuration animations:^{
      self.text = nil;
      self.textColor = textColorDefault;
      self.backgroundColor = bgColorDefault;
      self.frame = CGRectMake(tempFrame.origin.x+tempFrame.size.width/2, tempFrame.origin.y+tempFrame.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
      self.frame = tempFrame;
    }];
    
    
#endif
  }else{
    self.text = nil;
    self.textColor = textColorDefault;
    self.backgroundColor = bgColorDefault;
  }
}

-(NSString*)description
{
  return self.mShowNumber;
//  return [NSString stringWithFormat:@"empty:%@,number:%d,showNumber:%@",_mEmpty?@"YES":@"NO",_mNumber,_mShowNumber];
}

-(void)setMShowNumber:(NSString *)theShowNumber
{
  _mEmpty = NO;
  _mShowNumber = theShowNumber;
  self.text = theShowNumber;
}

-(void)setMBgColor:(UIColor *)theBgColor
{
  _mBgColor = theBgColor;
  self.backgroundColor = theBgColor;
}

-(void)setMTextColor:(UIColor *)theTextColor
{
  _mTextColor = theTextColor;
  self.textColor = theTextColor;
}

-(void)updateView:(int)theNuber showNumber:(NSString*)showNumber textColor:(UIColor*)theTextColor bgColor:(UIColor*)theBgColor
{
  _mEmpty = NO;
  if (self.mUseAnimotin) {
#ifdef easyoutAnimate
    float tempAlpha = self.alpha;
    if (_mNumber==0) {self.alpha = 0;}
    [UIView animateWithDuration:itemViewAnimateDuration animations:^{
      self.text = showNumber;
      self.textColor = theTextColor;
      self.backgroundColor = theBgColor;
      self.alpha = tempAlpha;
    } completion:^(BOOL finished) {
      
    }];
#else
    CGRect tempFrame = self.frame;
    self.frame = CGRectMake(tempFrame.origin.x+tempFrame.size.width/2, tempFrame.origin.y+tempFrame.size.height/2, 0, 0);
    [UIView animateWithDuration:itemViewAnimateDuration animations:^{
      self.text = showNumber;
      self.textColor = theTextColor;
      self.backgroundColor = theBgColor;
      self.frame = tempFrame;
    } completion:^(BOOL finished) {
      
    }];
#endif
  }else{
    self.text = showNumber;
    self.textColor = theTextColor;
    self.backgroundColor = theBgColor;
  }
  _mNumber = theNuber;
  _mShowNumber = showNumber;
  _mTextColor = theTextColor;
  _mBgColor = theBgColor;
}

-(void)playAnimotion:(BOOL)isOut
{
#ifdef easyoutAnimate
#else
#endif
  CGRect tempFrame = self.frame;
  self.frame = CGRectMake(tempFrame.origin.x+tempFrame.size.width/2, tempFrame.origin.y+tempFrame.size.height/2, 0, 0);
  [UIView animateWithDuration:itemViewAnimateDuration animations:^{
    self.frame = tempFrame;
  } completion:^(BOOL finished) {
    
  }];
}

@end





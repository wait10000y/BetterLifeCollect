//
//  Test2048ItemView.h
//  BetterLife
//
//  Created by shiliang.wang on 14/12/22.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Test2048ItemView : UILabel

@property (nonatomic) int mNumber;
@property (nonatomic) NSString *mShowNumber;
@property (nonatomic) UIColor *mBgColor;
@property (nonatomic) UIColor *mTextColor;
@property (nonatomic) BOOL mEmpty;

@property (nonatomic) BOOL mUseAnimotin;
//-(void)setEmptyTextColor:(UIColor*)theTextColor bgColor:(UIColor*)theBgColor;

-(void)emptyView;
-(void)updateView:(int)theNuber showNumber:(NSString*)showNumber textColor:(UIColor*)theTextColor bgColor:(UIColor*)theBgColor;

//-(void)playAnimotion;
@end



//
//  UIColor+BaseDefineColor.h
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GREY(color) [UIColor colorWithRed:color/255.0 green:color/255.0 blue:color/255.0 alpha:1]

@interface UIColor (BaseDefineColor)


+(UIColor*) appBackgroundColor;
+(UIColor*) appBlack1Color;
+(UIColor*) appOffWhiteColor;

@end

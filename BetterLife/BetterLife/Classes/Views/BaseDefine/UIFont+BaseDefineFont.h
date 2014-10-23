//
//  UIFont+BaseDefineFont.h
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 UILabel
 UITextFeild
 UItextView
 
 */
@interface UIFont (BaseDefineFont)

+(UIFont*) appFontOfSize:(CGFloat) pointSize;
+(UIFont*) boldAppFontOfSize:(CGFloat) pointSize;

@end

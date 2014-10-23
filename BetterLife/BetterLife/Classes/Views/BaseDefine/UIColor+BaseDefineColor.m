//
//  UIColor+BaseDefineColor.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "UIColor+BaseDefineColor.h"

@implementation UIColor (BaseDefineColor)


+(UIColor*) appBackgroundColor {
  
  return [UIColor colorWithPatternImage:[UIImage imageNamed:@"BGPattern"]];
}

+(UIColor*) appBlack1Color {
  
  return GREY(38);
  
}

+(UIColor*) appOffWhiteColor {
  
  return GREY(234);
  
}

@end

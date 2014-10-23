//
//  UIFont+BaseDefineFont.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "UIFont+BaseDefineFont.h"

@implementation UIFont (BaseDefineFont)


+(UIFont*) appFontOfSize:(CGFloat) pointSize {
  return [UIFont fontWithName:@"MyriadPro-Regular" size:pointSize];
}

+(UIFont*) boldAppFontOfSize:(CGFloat) pointSize {
  return [UIFont fontWithName:@"MyriadPro-Black" size:pointSize];
}

@end

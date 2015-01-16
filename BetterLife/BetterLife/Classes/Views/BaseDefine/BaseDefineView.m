//
//  BaseDefineView.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-23.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "BaseDefineView.h"

@implementation BaseDefineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(UIView*)loadNibView:(NSString*)theNibName
{
  NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:theNibName?:NSStringFromClass([self class]) owner:nil options:nil];
  if (viewArr.count>0) {
    return [viewArr firstObject];
  }
  return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

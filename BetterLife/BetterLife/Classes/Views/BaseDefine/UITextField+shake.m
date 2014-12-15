//
//  UITextField+shake.m
//  BetterLife
//
//  Created by shiliang.wang on 14-10-24.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "UITextField+shake.h"

@implementation UITextField (shake)


- (void)shake {
  CAKeyframeAnimation *animationKey = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  [animationKey setDuration:0.5f];
  
  NSArray *array = [[NSArray alloc] initWithObjects:
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                    [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                    nil];
  [animationKey setValues:array];
  
  NSArray *times = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithFloat:0.1f],
                    [NSNumber numberWithFloat:0.2f],
                    [NSNumber numberWithFloat:0.3f],
                    [NSNumber numberWithFloat:0.4f],
                    [NSNumber numberWithFloat:0.5f],
                    [NSNumber numberWithFloat:0.6f],
                    [NSNumber numberWithFloat:0.7f],
                    [NSNumber numberWithFloat:0.8f],
                    [NSNumber numberWithFloat:0.9f],
                    [NSNumber numberWithFloat:1.0f],
                    nil];
  [animationKey setKeyTimes:times];
  
  [self.layer addAnimation:animationKey forKey:@"TextFieldShake"];
}

@end

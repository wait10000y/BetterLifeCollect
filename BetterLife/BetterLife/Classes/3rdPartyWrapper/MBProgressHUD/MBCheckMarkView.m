//
//  NSCheckmarkView.m
//  Notestand
//
//  Created by M B. Bitar on 9/24/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBCheckMarkView.h"
#import <QuartzCore/QuartzCore.h>

#define largeSize 50
#define mediumSize 30
#define smallSize 14
#define xSmallSize 8

@implementation MBCheckMarkView

+(UIView *)warnViewWithSize:(MBCheckmarkSize)theSize color:(UIColor *)theColor
{
  CGSize xySize;
  switch (theSize) {
    case MBCheckmarkSizeLarge:
      xySize = CGSizeMake(largeSize, largeSize);
      break;
    case MBCheckmarkSizeMedium:
      xySize = CGSizeMake(mediumSize, mediumSize);
      break;
    case MBCheckmarkSizeSmall:
      xySize = CGSizeMake(smallSize, smallSize);
      break;
    case MBCheckmarkSizeVerySmall:
      xySize = CGSizeMake(xSmallSize, xSmallSize);
      break;
  }
  CGRect rect = CGRectMake(0, 0, xySize.width, xySize.height);
  UILabel *tempView = [[UILabel alloc] initWithFrame:rect];
  tempView.backgroundColor = [UIColor clearColor];
  tempView.textAlignment = NSTextAlignmentCenter;
  tempView.textColor = theColor==nil?[UIColor whiteColor]:theColor;
  tempView.text = @"!";
  tempView.font = [UIFont boldSystemFontOfSize:xySize.width+4];
  return tempView;
}

+(MBCheckMarkView*)checkMarkWithSize:(MBCheckmarkSize)size color:(UIColor*)color
{
    CGSize xySize;
    switch (size) {
        case MBCheckmarkSizeLarge:
            xySize = CGSizeMake(largeSize, largeSize);
            break;
        case MBCheckmarkSizeMedium:
            xySize = CGSizeMake(mediumSize, mediumSize);
            break;
        case MBCheckmarkSizeSmall:
            xySize = CGSizeMake(smallSize, smallSize);
            break;
        case MBCheckmarkSizeVerySmall:
            xySize = CGSizeMake(xSmallSize, xSmallSize);
            break;
    }
    
    CGRect rect = CGRectMake(0, 0, xySize.width, xySize.height);
    MBCheckMarkView *checkMark = [[MBCheckMarkView alloc] initWithFrame:rect];
    checkMark.size = size;
    checkMark.opaque = NO;
  checkMark.color = color==nil?[UIColor whiteColor]:color;
    return checkMark;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}


UIBezierPath *CheckMarkPath(CGRect frame)
{
    float p = CGRectGetHeight(frame) / 90;
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0*p, 42*p)];
    [bezierPath addLineToPoint: CGPointMake(16*p, 26*p)];
    [bezierPath addLineToPoint: CGPointMake(32*p, 42*p)];
    [bezierPath addLineToPoint: CGPointMake(74*p, 0*p)];
    [bezierPath addLineToPoint: CGPointMake(90*p, 16*p)];
    [bezierPath addLineToPoint: CGPointMake(32*p, 74*p)];
    [bezierPath addLineToPoint: CGPointMake(0*p, 42*p)];
    [bezierPath closePath];
    return bezierPath;
}

-(void)drawLarge
{
    UIBezierPath* bezierPath = CheckMarkPath(CGRectMake(0, 0, 0, largeSize));
    [bezierPath fill];
}

-(void)drawMedium
{
    UIBezierPath* bezierPath = CheckMarkPath(CGRectMake(0, 0, 0, mediumSize));
    [bezierPath fill];
}

-(void)drawSmall
{
    UIBezierPath* bezierPath = CheckMarkPath(CGRectMake(0, 0, 0, smallSize));
    [bezierPath fill];
}

-(void)drawVerySmall
{
    UIBezierPath* bezierPath = CheckMarkPath(CGRectMake(0, 0, 0, xSmallSize));
    [bezierPath fill];
}

- (void)drawRect:(CGRect)rect
{
    [_color setFill];
    if(_size == MBCheckmarkSizeVerySmall)
        [self drawVerySmall];
    else if(_size == MBCheckmarkSizeSmall)
        [self drawSmall];
    else if(_size == MBCheckmarkSizeMedium)
        [self drawMedium];
    else if(_size == MBCheckmarkSizeLarge)
        [self drawLarge];
}


@end

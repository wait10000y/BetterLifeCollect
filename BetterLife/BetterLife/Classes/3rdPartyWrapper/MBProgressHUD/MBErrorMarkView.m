//
//  NSCheckmarkView.m
//  Notestand
//
//  Created by M B. Bitar on 9/24/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBErrorMarkView.h"
#import <QuartzCore/QuartzCore.h>

 #define largeSize 25
 #define mediumSize 15
 #define smallSize 7
 #define xSmallSize 4

#define CGPointWithOffset(originPoint, offsetPoint) CGPointMake(originPoint.x + offsetPoint.x, originPoint.y + offsetPoint.y)

@implementation MBErrorMarkView


+(MBErrorMarkView*)errorMarkWithSize:(MBErrormarkSize)size color:(UIColor*)color
{
    CGSize xySize;
    switch (size) {
        case MBErrormarkSizeLarge:
            xySize = CGSizeMake(largeSize, largeSize);
            break;
        case MBErrormarkSizeMedium:
            xySize = CGSizeMake(mediumSize, mediumSize);
            break;
        case MBErrormarkSizeSmall:
            xySize = CGSizeMake(smallSize, smallSize);
            break;
        case MBErrormarkSizeVerySmall:
            xySize = CGSizeMake(xSmallSize, xSmallSize);
            break;
    }
    
    CGRect rect = CGRectMake(0, 0, xySize.width, xySize.height);
    MBErrorMarkView *checkMark = [[MBErrorMarkView alloc] initWithFrame:rect];
    checkMark.size = size;
    checkMark.opaque = NO;
  checkMark.color = color==nil?[UIColor whiteColor]:color;
    return checkMark;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}


UIBezierPath *ErrorMarkPath(CGRect frame){
  CGFloat scale = 1;
  CGFloat thick = 7;
  
  CGFloat height     = CGRectGetHeight(frame) * scale;
  CGFloat width      = CGRectGetWidth(frame)  * scale;
  CGFloat halfHeight = height / 2.f;
  CGFloat halfWidth  = width  / 2.f;
  CGFloat size       = height < width ? height : width;
  CGFloat offset     = thick / sqrt(2.f);
  
  CGPoint offsetPoint = CGPointMake(CGRectGetMinX(frame) + (CGRectGetWidth(frame)  - size) / 2.f,CGRectGetMinY(frame) + (CGRectGetHeight(frame) - size) / 2.f);
  
  UIBezierPath * path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointWithOffset(CGPointMake(0.f, offset), offsetPoint)];                       // a
  [path addLineToPoint:CGPointWithOffset(CGPointMake(offset, 0.f), offsetPoint)];                    // b
  [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth, halfHeight - offset), offsetPoint)]; // c
  [path addLineToPoint:CGPointWithOffset(CGPointMake(width - offset, 0.f), offsetPoint)];            // d
  [path addLineToPoint:CGPointWithOffset(CGPointMake(width, offset), offsetPoint)];                  // e
  [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth + offset, halfHeight), offsetPoint)]; // f
  [path addLineToPoint:CGPointWithOffset(CGPointMake(width, height - offset), offsetPoint)];         // g
  [path addLineToPoint:CGPointWithOffset(CGPointMake(width - offset, height), offsetPoint)];         // h
  [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth, halfHeight + offset), offsetPoint)]; // i
  [path addLineToPoint:CGPointWithOffset(CGPointMake(offset, height), offsetPoint)];                 // j
  [path addLineToPoint:CGPointWithOffset(CGPointMake(0.f, height - offset), offsetPoint)];           // k
  [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth - offset, halfHeight), offsetPoint)]; // l
  [path closePath];
  return path;
}

-(void)drawLarge
{
  UIBezierPath* bezierPath = ErrorMarkPath(CGRectMake(0, 0, largeSize, largeSize));
  [bezierPath fill];
}

-(void)drawMedium
{
  UIBezierPath* bezierPath = ErrorMarkPath(CGRectMake(0, 0, mediumSize, mediumSize));
  [bezierPath fill];
}

-(void)drawSmall
{
  UIBezierPath* bezierPath = ErrorMarkPath(CGRectMake(0, 0, smallSize, smallSize));
  [bezierPath fill];
}

-(void)drawVerySmall
{
  UIBezierPath* bezierPath = ErrorMarkPath(CGRectMake(0, 0, xSmallSize, xSmallSize));
  [bezierPath fill];
}

- (void)drawRect:(CGRect)rect
{
  [_color setFill];
  if(_size == MBErrormarkSizeVerySmall)
    [self drawVerySmall];
  else if(_size == MBErrormarkSizeSmall)
    [self drawSmall];
  else if(_size == MBErrormarkSizeMedium)
    [self drawMedium];
  else if(_size == MBErrormarkSizeLarge)
    [self drawLarge];
}


@end

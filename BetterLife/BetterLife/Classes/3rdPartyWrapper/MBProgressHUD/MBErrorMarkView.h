//
//  MBErrorMarkView.h
//  Notestand
//
//  Created by M B. Bitar on 9/24/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MBErrormarkSizeVerySmall,
    MBErrormarkSizeSmall,
    MBErrormarkSizeMedium,
    MBErrormarkSizeLarge
}MBErrormarkSize;

@interface MBErrorMarkView : UIView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) MBErrormarkSize size;

+(MBErrorMarkView*)errorMarkWithSize:(MBErrormarkSize)size color:(UIColor*)color;

@end

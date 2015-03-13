//
//  UIKeyboardView.m
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardView.h"

  //#define key_string_previous   @"previous" // NSLocalizedString(@"previous", @"")
//#define key_string_next       @"next"
//#define key_string_done       @"done"

#define key_string_previous   @"上一个"
#define key_string_next       @"下一个"
#define key_string_done       @"完  成"

@implementation UIKeyboardView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:frame];
		
		keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
		
		UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:key_string_previous style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonTap:)];
		previousBarItem.tag=1;
		
		UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:key_string_next style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonTap:)];
		nextBarItem.tag=2;
		
		UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:key_string_done style:UIBarButtonItemStyleDone target:self action:@selector(toolbarButtonTap:)];
		doneBarItem.tag=3;
		
		[keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
      [self addSubview:keyboardToolbar];

    }
    return self;
}

-(void)changeFrame:(CGRect)theFrame
{
  self.frame = theFrame;
  if (keyboardToolbar) {
    keyboardToolbar.frame = theFrame;
//    [self addSubview:keyboardToolbar];
  }
}

- (void)toolbarButtonTap:(UIButton *)button {
	if ([self.delegate respondsToSelector:@selector(toolbarButtonTap:)]) {
		[self.delegate toolbarButtonTap:button];
	}
}

@end

@implementation UIKeyboardView (UIKeyboardViewAction)

//根据index找出对应的UIBarButtonItem
- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex {
	if (itemIndex < [[keyboardToolbar items] count]) {
		return [[keyboardToolbar items] objectAtIndex:itemIndex];
	}
	return nil;
}

@end

//
//  UIKeyboardViewController.h
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardView.h"

@protocol UIKeyboardViewControllerDelegate;

@interface UIKeyboardViewController : NSObject
@property (nonatomic, weak) id <UIKeyboardViewControllerDelegate> boardDelegate;
@property (atomic) BOOL autoHideHitBg; // auto hide hit background;

+(void)resignKeyboard;
- (void)resignKeyboard:(UIView *)resignView;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerCreation)
/* Is not recommended，just for old code */
- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)theDelegateObject;

/* delegateObject is controled view */
- (id)initWithControllerView:(UIView *)theControlView withDelegate:(id <UIKeyboardViewControllerDelegate>)theDelegate;
/* default 0 */
-(void)setDelegateOffsetBottom:(NSInteger)theOffset;
-(BOOL)startControl;
-(BOOL)stopControl;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerAction)

- (void)addToolbarToKeyboard;

@end

@protocol UIKeyboardViewControllerDelegate <NSObject>

@optional

- (BOOL)alttextFieldShouldBeginEditing:(UITextField *)textField;
- (void)alttextFieldDidBeginEditing:(UITextField *)textField;
- (void)alttextFieldEditingChanged:(UITextField *)textField;
- (void)alttextFieldDidEndEditing:(UITextField *)textField;


- (BOOL)alttextViewShouldBeginEditing:(UITextView *)textView;
- (void)alttextViewDidBeginEditing:(UITextView *)textView;
- (void)alttextViewEditingChanged:(UITextView *)textView;
- (void)alttextViewDidEndEditing:(UITextView *)textView;

- (void)keyboardFrameChanged;
@end

//
//  UIKeyboardViewController.m
// 
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardViewController.h"


static CGFloat keyBoardToolbarHeight = 38.0f;
static CGFloat spacerY = 4.0f;


@interface UIKeyboardViewController () <UITextFieldDelegate, UIKeyboardViewDelegate, UITextViewDelegate>

- (void)animateView:(BOOL)isShow animateTime:(CGFloat)duration textField:(id)textField heightforkeyboard:(CGFloat)kheight;
- (void)addKeyBoardNotification;
- (void)removeKeyBoardNotification;
- (void)checkBarButton:(id)textField;
- (id)firstResponder:(UIView *)navView;
- (NSArray *)allSubviews:(UIView *)theView;
- (void)resignKeyboard:(UIView *)resignView;

@end

@implementation UIKeyboardViewController
{

  CGRect keyboardBounds;
  CGFloat kboardHeight; // 254
  
  UIView *objectView;
  CGFloat objectViewFrameY;
  CGFloat scrollOffsetY;
  NSInteger objectViewGapScreenBottom;
  
	UIKeyboardView *keyboardToolbar;
  NSArray *allInputViews;
  UITapGestureRecognizer *tapRecognizer;
}

//监听键盘隐藏和显示事件
- (void)addKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

//注销监听事件
- (void)removeKeyBoardNotification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//计算当前键盘的高度
-(void)keyboardWillShowOrHide:(NSNotification *)notification {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//#endif
//		kboardHeight = 264.0f + keyBoardToolbarHeight;
//	}
//	NSValue *keyboardBoundsValue;
//	if (IOS_VERSION >= 3.2) {
//	}
//	else {
//		keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
//	}
  
  NSDictionary* info = [notification userInfo];

  CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  UIInterfaceOrientation orie = [UIApplication sharedApplication].statusBarOrientation;
  if (orie == UIInterfaceOrientationLandscapeLeft || orie == UIInterfaceOrientationLandscapeRight) {
    kboardHeight = kbFrame.size.width;
    if (keyboardToolbar) {[keyboardToolbar changeFrame:CGRectMake(0, 0, kbFrame.size.height, keyBoardToolbarHeight)];}
  }else{
    kboardHeight = kbFrame.size.height;
    if (keyboardToolbar) {[keyboardToolbar changeFrame:CGRectMake(0, 0, kbFrame.size.width, keyBoardToolbarHeight)];}
  }
  
  NSValue *keyboardBoundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	[keyboardBoundsValue getValue:&keyboardBounds];
  
    double animateDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	BOOL isShow = [[notification name] isEqualToString:UIKeyboardWillShowNotification] ? YES : NO;
  
  [self animateView:isShow animateTime:animateDuration textField:[self firstResponder:objectView] heightforkeyboard:kboardHeight];
    if ([self.boardDelegate respondsToSelector:@selector(keyboardFrameChanged)]) {
		[self.boardDelegate keyboardFrameChanged];
	}
}

-(UIView *)findKeyboardView
{
  UIWindow* tmpWindow;
  UIView* keyboard;

    // Check each window in our application
  for(int i = 0; i < [[[UIApplication sharedApplication] windows] count]; i++)
  {
      // Get a reference of the current window
    tmpWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:i];
    for(int j = 0; j < [tmpWindow.subviews count]; j++)
    {
      keyboard = [tmpWindow.subviews objectAtIndex:j];
        // From all the apps i have made, they keyboard view description always starts with <UIKeyboard so I did the following
      if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
      {
        UIButton* key = [UIButton buttonWithType:UIButtonTypeCustom];
        [key setTitle:@"haha" forState:UIControlStateNormal];

        key.frame = CGRectMake(2, 10, 31, 46);

//          [key setImage:[UIImage imageNamed:@"key.png"] forState:UIControlStateNormal];
//          [key setImage:[UIImage imageNamed:@"key-pressed.png"] forState:UIControlStateHighlighted];

        [keyboard addSubview:key];
//          [key addTarget:self action:@selector(keypressed:)  forControlEvents:UIControlEventTouchUpInside];

        return keyboard;
      }
    }
  }
  return nil;
}

//输入框上移防止键盘遮挡
- (void)animateView:(BOOL)isShow animateTime:(CGFloat)duration textField:(id)textField heightforkeyboard:(CGFloat)kheight {
  if (textField) {
    
  }
	[self checkBarButton:textField];
  [UIView animateWithDuration:duration animations:^{
    CGRect rect = objectView.frame;
	if (isShow) {
//		if ([textField isKindOfClass:[UITextField class]]) { // UITextField
			UIView *newText = ((UIView *)textField);
			CGPoint textPoint = [newText convertPoint:CGPointMake(0, newText.frame.size.height + spacerY) toView:objectView];

      if ([objectView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)objectView;
        if (textPoint.y-newText.frame.size.height < scrollOffsetY) {
          scrollOffsetY = (textPoint.y-newText.frame.size.height);
          if (scrollOffsetY <0) {scrollOffsetY = 0;}
          scroll.contentOffset = CGPointMake(0, scrollOffsetY);
        }else if (rect.size.height+scrollOffsetY <textPoint.y) {
          if ([objectView isKindOfClass:[UIScrollView class]]) {
            scrollOffsetY = (textPoint.y-rect.size.height);
            if (scrollOffsetY > scroll.contentSize.height - rect.size.height) {scrollOffsetY = scroll.contentSize.height - rect.size.height;}
            scroll.contentOffset = CGPointMake(0, scrollOffsetY);
          }
        }
      }

			if (rect.size.height + scrollOffsetY - textPoint.y +objectViewGapScreenBottom < kheight){
				rect.origin.y = rect.size.height +scrollOffsetY - textPoint.y - kheight + objectViewGapScreenBottom + objectViewFrameY;
      } else {
        rect.origin.y = objectViewFrameY;
      }
//		} else { // UITextView
//			UITextView *newView = ((UITextView *)textField);
//			CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + spacerY) toView:objectView];
//			if (rect.size.height - textPoint.y + objectViewOffsetBottom < kheight) 
//				rect.origin.y = rect.size.height - textPoint.y - kheight + objectViewOffsetBottom + objectViewFrameY;
//			else rect.origin.y = objectViewFrameY;
//		}
	}else{
    rect.origin.y = objectViewFrameY;
  }
	objectView.frame = rect;
  } completion:^(BOOL finished) {
//    [self findKeyboardView];
  }];
}

//输入框获得焦点
- (id)firstResponder:(UIView *)navView {
	for (UIView *aview in allInputViews) {
    if ([aview isFirstResponder]) {
      return aview;
    }
	}
	return nil;
}

//找出所有的subview
- (NSArray *)allSubviews:(UIView *)theView {
	NSArray *results = [theView subviews];
	for (UIView *eachView in [theView subviews]) {
		NSArray *riz = [self allSubviews:eachView];
		if (riz) {
			results = [results arrayByAddingObjectsFromArray:riz];
		}
	}
	return results;
}

-(NSArray *)findInputItems:(NSArray *)theViews
{
  NSMutableArray *inputs;
  if (theViews.count>0) {
    inputs = [[NSMutableArray alloc] init];
    for (UIView *aView in theViews) {
      if ([aView isKindOfClass:[UITextField class]] || [aView isKindOfClass:[UITextView class]]) {
        [inputs addObject:aView];
      }
    }
  }
  return inputs;
}
+(void)resignKeyboard
{
  [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
//输入框失去焦点，隐藏键盘
- (void)resignKeyboard:(UIView *)resignView
{
//  [UIKeyboardViewController resignKeyboard];
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//设置previousBarItem或nextBarItem是否允许点击
- (void)checkBarButton:(id)textField {
	int i = 0,j = 0;
	UIBarButtonItem *previousBarItem = [keyboardToolbar itemForIndex:0];
    UIBarButtonItem *nextBarItem = [keyboardToolbar itemForIndex:1];
	for (id aview in allInputViews) {
		if ([aview isKindOfClass:[UITextField class]] && !((UITextField*)aview).hidden && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) {
			i++;
			if ([(UITextField *)aview isEqual:textField]) {
				j = i;
			}
		}
		else if ([aview isKindOfClass:[UITextView class]] && !((UITextView*)aview).hidden && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
			i++;
			if ([(UITextView *)aview isEqual:textField]) {
				j = i;
			}
		}
	}
	[previousBarItem setEnabled:j > 1 ? YES : NO];
	[nextBarItem setEnabled:j < i ? YES : NO];
}

//toolbar button点击事件
#pragma mark - UIKeyboardView delegate methods
-(void)toolbarButtonTap:(UIButton *)button {
	NSInteger buttonTag = button.tag;
	NSMutableArray *textFieldArray=[NSMutableArray arrayWithCapacity:10];
	for (id aview in allInputViews) {
		if ([aview isKindOfClass:[UITextField class]] && !((UITextField*)aview).hidden && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) {
			[textFieldArray addObject:(UITextField *)aview];
		}
		else if ([aview isKindOfClass:[UITextView class]] && !((UITextView*)aview).hidden && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
			[textFieldArray addObject:(UITextView *)aview];
		}
	}
	for (int i = 0; i < [textFieldArray count]; i++) {
		id textField = [textFieldArray objectAtIndex:i];
		if ([textField isFirstResponder]) {
			if (buttonTag == 1) {
				if (i > 0) {
          if ([[textFieldArray objectAtIndex:--i] becomeFirstResponder]) {
//            [self animateView:YES animateTime:0.25 textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
          }else{
            [textField resignFirstResponder];
          }
					
				}
			}
			else if (buttonTag == 2) {
				if (i < [textFieldArray count] - 1) {
          if ([[textFieldArray objectAtIndex:++i] becomeFirstResponder]) {
//            [self animateView:YES animateTime:0.25 textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
          }else{
            [textField resignFirstResponder];
          }
				}
			}
		}
	}
	if (buttonTag == 3) 
		[self resignKeyboard:objectView];
}


#pragma mark - TextField delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  if ([self.boardDelegate respondsToSelector:@selector(alttextFieldShouldBeginEditing:)]) {
		return [self.boardDelegate alttextFieldShouldBeginEditing:textField];
	}
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self animateView:YES animateTime:0.25 textField:textField heightforkeyboard:kboardHeight];
  if ([self.boardDelegate respondsToSelector:@selector(alttextFieldDidBeginEditing:)]) {
		[self.boardDelegate alttextFieldDidBeginEditing:textField];
	}
	[self checkBarButton:textField];
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([self.boardDelegate respondsToSelector:@selector(alttextFieldDidEndEditing:)]) {
		[self.boardDelegate alttextFieldDidEndEditing:textField];
	}
}

#pragma mark - UITextView delegate methods
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {    
//	if ([text isEqualToString:@"\n"]) {    
//		[textView resignFirstResponder];    
//		return NO;    
//	}
//	return YES;    
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  if ([self.boardDelegate respondsToSelector:@selector(alttextViewShouldBeginEditing:)]) {
		return [self.boardDelegate alttextViewShouldBeginEditing:textView];
	}
  return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [self animateView:YES animateTime:0.25 textField:textView heightforkeyboard:kboardHeight];
  if ([self.boardDelegate respondsToSelector:@selector(alttextViewDidBeginEditing:)]) {
		[self.boardDelegate alttextViewDidBeginEditing:textView];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([self.boardDelegate respondsToSelector:@selector(alttextViewDidEndEditing:)]) {
		[self.boardDelegate alttextViewDidEndEditing:textView];
	}
}

- (void)textViewDidChange:(UITextView *)textView
{
  if ([self.boardDelegate respondsToSelector:@selector(alttextViewEditingChanged:)]) {
		[self.boardDelegate alttextViewEditingChanged:textView];
	}
}

@end

@implementation UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)theDelegate
{
  if (self = [super init]) {
		self.boardDelegate = theDelegate;
    objectViewGapScreenBottom = 0;
    scrollOffsetY = 0;
    if ([self.boardDelegate isKindOfClass:[UIViewController class]]) {
			objectView = [(UIViewController *)[self boardDelegate] view];
		}else if ([self.boardDelegate isKindOfClass:[UIView class]]) {
			objectView = (UIView *)[self boardDelegate];
		}
    objectViewFrameY = objectView.frame.origin.y;
    allInputViews = [self findInputItems:[self allSubviews:objectView]];
		[self addKeyBoardNotification];
	}
	return self;
}

- (id)initWithControllerView:(UIView *)theControlView withDelegate:(id <UIKeyboardViewControllerDelegate>)theDelegate {
	if (self = [super init]) {
		self.boardDelegate = theDelegate;
    objectView = theControlView;
    objectViewGapScreenBottom = 0;
    scrollOffsetY = 0;
    objectViewFrameY = objectView.frame.origin.y;
    _autoHideHitBg = YES;
	}
	return self;
}

-(void)setDelegateOffsetBottom:(NSInteger)theOffset
{
  objectViewGapScreenBottom = theOffset;
}


-(BOOL)startControl
{
  
  allInputViews = [self findInputItems:[self allSubviews:objectView]];
  [self addToolbarToKeyboard];
  [self addKeyBoardNotification];
  return YES;
}

-(BOOL)stopControl
{
    [self removeKeyBoardNotification];
  if (allInputViews) {
    for (UIView *aview in allInputViews) {
      if ([aview isKindOfClass:[UITextField class]] || [aview isKindOfClass:[UITextView class]]) {
        ((UITextField *)aview).inputAccessoryView = nil;
        ((UITextField *)aview).delegate = nil;
        if ([aview isKindOfClass:[UITextField class]] && [self.boardDelegate respondsToSelector:@selector(alttextFieldEditingChanged:)]) {
          [((UITextField *)aview) removeTarget:self.boardDelegate action:@selector(alttextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        }
      }
    }

    if (self.autoHideHitBg && tapRecognizer) {
      [objectView removeGestureRecognizer:tapRecognizer];
    }

//    if ([objectView isKindOfClass:[UIControl class]]) {
//      UIControl *control = (UIControl *)objectView;
//      [control removeTarget:self action:@selector(resignKeyboard:) forControlEvents:UIControlEventTouchDown];
//    }
  }
  allInputViews = nil;
  keyboardToolbar = nil;
  kboardHeight = 0;
  return YES;
}

@end

@implementation UIKeyboardViewController (UIKeyboardViewControllerAction)

//给键盘加上toolbar
- (void)addToolbarToKeyboard {
	keyboardToolbar = [[UIKeyboardView alloc] initWithFrame:CGRectMake(0, 0, objectView.frame.size.width, keyBoardToolbarHeight)];
	keyboardToolbar.delegate = self;
  
  for (UIView *aview in allInputViews) {
		if ([aview isKindOfClass:[UITextField class]] || [aview isKindOfClass:[UITextView class]]) {
			((UITextField *)aview).inputAccessoryView = keyboardToolbar;
			((UITextField *)aview).delegate = self;
      if ([aview isKindOfClass:[UITextField class]] && [self.boardDelegate respondsToSelector:@selector(alttextFieldEditingChanged:)]) {
        [((UITextField *)aview) addTarget:self.boardDelegate action:@selector(alttextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
      }
		}
	}
  
  if (self.autoHideHitBg) {
    if (!tapRecognizer) {
      tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
      tapRecognizer.cancelsTouchesInView = NO;
    }
    [objectView addGestureRecognizer:tapRecognizer];
  }

//  if ([objectView isKindOfClass:[UIControl class]]) {
//    UIControl *control = (UIControl *)objectView;
//    [control addTarget:self action:@selector(resignKeyboard:) forControlEvents:UIControlEventTouchDown];
//  }
  
//	for (id aview in allInputViews) {
//		if ([aview isKindOfClass:[UITextField class]]) {
//			((UITextField *)aview).inputAccessoryView = keyboardToolbar;
//			((UITextField *)aview).delegate = self;
//		}else if ([aview isKindOfClass:[UITextView class]]) {
//			((UITextView *)aview).inputAccessoryView = keyboardToolbar;
//			((UITextView *)aview).delegate = self;
//		}
//	}

}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
  [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end

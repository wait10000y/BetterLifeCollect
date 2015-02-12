//
//  SVCPopoView.m
//  TifClient
//
//  Created by shiliang.wang on 15/2/10.
//  Copyright (c) 2015年 doggy. All rights reserved.
//

#import "SVCPopoView.h"

#define UIViewAutoresizingAll (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin)

float offsetLeft = 3;
float offsetRight = 3;
float offsetTop = 3;
float offsetButtom = 3;
float offsetSpace = 2;

@implementation SVCPopoView
{
  UIScrollView *mScrollView;
  UIImageView *mBgView;
  
  SVCPopoActionBack mBlock;
  SVCPopoView *mPopoView;
  NSArray *mButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.sizeMax = frame.size;
    }
    return self;
}

-(void)showLeftPopoInView:(UIView*)theView withPoint:(CGPoint)thePoint withButtons:(NSArray*)theButtons actionBack:(SVCPopoActionBack)theBlock;
{
  mBlock = theBlock;
  mButtons = [NSArray arrayWithArray:theButtons];
  if (!mScrollView) {
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1,1)];
  }
  [self addButtonsView:mButtons];
  CGSize theSize = mScrollView.contentSize;
  CGSize viewSzie = CGSizeMake(theSize.width+offsetLeft+offsetRight, theSize.height+offsetTop+offsetButtom);
  if (!CGSizeEqualToSize(self.sizeMax, CGSizeZero)) {
    viewSzie = CGSizeMake(MIN(viewSzie.width, self.sizeMax.width), MIN(viewSzie.height, self.sizeMax.height));
  }
  mScrollView.frame = CGRectMake(offsetLeft, offsetTop, viewSzie.width-offsetLeft-offsetRight, viewSzie.height-offsetTop-offsetButtom);
  self.frame = CGRectMake(thePoint.x-viewSzie.width-offsetSpace,thePoint.y-viewSzie.height/2, viewSzie.width,viewSzie.height);
  NSLog(@"------pop frame:%@ -------",NSStringFromCGRect(self.frame));
  if (!mBgView) {
    self.backgroundColor = [UIColor clearColor];
    UIImage *resizeImage = [[UIImage imageNamed:@"ppt_palette_tool_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake( offsetTop, offsetLeft, offsetButtom, offsetRight)];
    mBgView = [[UIImageView alloc] initWithImage:resizeImage];
    mBgView.contentMode = UIViewContentModeScaleToFill;
    mBgView.autoresizingMask = UIViewAutoresizingAll;
  }
  mBgView.frame = self.bounds;
  [self addSubview:mBgView];
  [self addSubview:mScrollView];
  [theView addSubview:self];
}

-(void)addButtonsView:(NSArray*)theButtons
{
  float tempOffset = 0;
  float tempHeight = 0;
  for (int it=0; it<theButtons.count; it++) {
    UIButton *btn = theButtons[it];
    CGRect tempFrame = btn.frame;
    tempFrame.origin.x = tempOffset;
    tempFrame.origin.y = 0;
    btn.frame = tempFrame;
    [btn addTarget:self action:@selector(actionItemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [mScrollView addSubview:btn];
    tempOffset += tempFrame.size.width+offsetSpace;
    tempHeight = tempHeight>tempFrame.size.height?tempHeight:tempFrame.size.height;
  }
  mScrollView.contentSize = CGSizeMake(tempOffset-offsetSpace, tempHeight);
}

-(IBAction)actionItemSelected:(UIButton*)sender
{
  if (mBlock) {
    mBlock(sender,[mButtons indexOfObject:sender]);
  }
  [self dismmisView];
}

-(void)dismmisView
{
  if (self.superview) {
    [UIView animateWithDuration:0.2 animations:^{
      self.alpha = 0;
    } completion:^(BOOL finished) {
      [self removeFromSuperview];
    }];
  }
}


-(void)createPopoViewWithPoint:(CGPoint)thePoint withButtons:(NSArray*)theArray
{
//  self.backgroundColor = [UIColor clearColor];
//  
//  UIImage *resizeImage = [[UIImage imageNamed:@"ppt_palette_tool_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake( offsetTop, offsetLeft, offsetButtom, offsetRight)];
//  UIImageView *bgImageView = [[UIImageView alloc] initWithImage:resizeImage];
//  bgImageView.contentMode = UIViewContentModeScaleToFill;
//  bgImageView.autoresizingMask = UIViewAutoresizingAll;
//  bgImageView.frame = self.bounds;
//  [self addSubview:bgImageView];
//  
//  
//  
//  float tempOffset = offsetLeft;
//  float tempHeight = offsetTop+offsetButtom;
//  
//  for (int it=0; it<theArray.count; it++) {
//    UIButton *btn = theArray[it];
//    CGRect tempFrame = btn.frame;
//    tempFrame.origin.x = tempOffset;
//    tempFrame.origin.y = offsetTop;
//    btn.frame = tempFrame;
//    [view addSubview:btn];
//    tempOffset += tempFrame.size.width+offsetSpace;
//    float tempHeightNow = tempFrame.size.height+offsetTop+offsetButtom;
//    tempHeight = tempHeight>tempHeightNow?tempHeight:tempHeightNow;
//  }
//  CGSize viewSize = CGSizeMake(tempOffset+offsetRight, tempHeight);
//  view.frame = CGRectMake(thePoint.x-viewSize.width-offsetSpace, thePoint.y-viewSize.height/2,viewSize.width,viewSize.height);
//  return view;
}


@end

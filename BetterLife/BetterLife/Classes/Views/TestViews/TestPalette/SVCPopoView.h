//
//  SVCPopoView.h
//  TifClient
//
//  Created by shiliang.wang on 15/2/10.
//  Copyright (c) 2015年 doggy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SVCPopoActionBack) (id selectItem,NSInteger index);

@interface SVCPopoView : UIView
@property (nonatomic) CGSize sizeMax;
-(void)showLeftPopoInView:(UIView*)theView withPoint:(CGPoint)thePoint withButtons:(NSArray*)theButtons actionBack:(SVCPopoActionBack)theBlock;

-(void)dismmisView;


@end

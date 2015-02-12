//
//  TestPaletteViewController.h
//  BetterLife
//
//  Created by shiliang.wang on 15/2/4.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"

@class SVCClassPaletteView;
@interface TestPaletteViewController : BaseDefineViewController

@property (weak, nonatomic) IBOutlet SVCClassPaletteView *paletteView;

-(IBAction)actionTakePhoto:(UIButton*)sender;

@end

//
//  TestPaletteViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/2/4.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestPaletteViewController.h"
#import "SVCClassPaletteView.h"

@interface TestPaletteViewController ()<SVCPaletteViewDelegate>

@end

@implementation TestPaletteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  BaseDefineNavigationController *bdncv = (BaseDefineNavigationController*)self.navigationController;
  bdncv.canDragBack = NO;
  if (bdncv) {
  }
  
//  SVCClassPaletteView *paletteView = [[[NSBundle mainBundle] loadNibNamed:@"SVCClassPaletteView" owner:nil options:nil] lastObject];
  if (self.paletteView) {
    self.paletteView.mViewController = self;
    self.paletteView.delegate = self;
    [self.paletteView createDefaultData];
//    self.paletteView.frame = self.view.bounds;
//    [self.view addSubview:self.paletteView];
  }
}

-(void)viewWillAppear:(BOOL)animated
{
  self.disableAutorotate = YES;
  [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
  self.disableAutorotate = NO;
  BaseDefineNavigationController *bdncv = (BaseDefineNavigationController*)self.navigationController;
  bdncv.canDragBack = YES;
  [super viewWillDisappear:animated];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionTakePhoto:(UIButton*)sender
{
  [self.paletteView takePhptoForBg];
}

-(void)paletteViewToolsViewStatusChanged:(BOOL)isShow
{
  
}

-(void)paletteViewTakeSnapshoot:(UIImage*)thePhoto forOpration:(SVCPaletteOprationType)theOpration
{
    //TODO: 保存 图片
  NSLog(@"------ paletteViewTakeSnapshoot:%@,type:%d -------",thePhoto,theOpration);
  switch (theOpration) {
    case SVCPaletteOprationSavePhoto: // 保存
    {
      UIImageWriteToSavedPhotosAlbum(thePhoto, self, nil, nil);
    } break;
    case SVCPaletteOprationSharePhoto: // 分享
    {
      
    } break;
    case SVCPaletteOprationMoveToTrach: // 删除
    {
      
    } break;
      
    default:
      break;
  }
  
}


@end

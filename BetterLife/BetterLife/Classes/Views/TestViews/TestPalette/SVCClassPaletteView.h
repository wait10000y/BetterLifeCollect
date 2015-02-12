//
//  SVCClassPaletteView.h
//  IECS
//
//  Created by shiliang.wang on 15/2/6.
//  Copyright (c) 2015年 XOR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
  SVCBrushItemBrush,
  SVCBrushItemEraser
}SVCBrushItemType;

typedef enum{
  SVCPaletteOprationSavePhoto,
  SVCPaletteOprationSharePhoto,
  SVCPaletteOprationMoveToTrach
}SVCPaletteOprationType;

@protocol SVCPaletteViewDelegate <NSObject>

@optional
-(void)paletteViewToolsViewStatusChanged:(BOOL)isShow;
-(void)paletteViewTakeSnapshoot:(UIImage*)thePhoto forOpration:(SVCPaletteOprationType)theOpration;

@end

@interface SVCPaletteView : UIView
@property (nonatomic) UIColor *curColor;
@property (nonatomic) float curWidth;
@property (nonatomic) SVCBrushItemType curType;

-(void)defaultNewDatas;

-(void)undoLast;
-(void)redoLast;
-(void)clearAll;

@end

@interface SVCClassPaletteView : UIView
@property (weak, nonatomic) IBOutlet UITableView *toolsView;
@property (weak, nonatomic) IBOutlet SVCPaletteView *paletteView;
@property (weak, nonatomic) UIViewController *mViewController;// for take photo
@property (weak,nonatomic) id<SVCPaletteViewDelegate> delegate;
  // 初始化
-(void)createDefaultData;

  // 添加背景图片
-(void)addBgImage:(UIImage*)theImage;
-(void)clearAll;
  //显示/隐藏 工具条
-(void)showToolListView:(BOOL)isShow;

-(UIImage*)takePaletteViewPhoto;

-(void)takePhptoForBg;

@end







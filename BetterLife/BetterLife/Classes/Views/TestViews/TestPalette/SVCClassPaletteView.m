 //
//  SVCClassPaletteView.m
//  IECS
//
//  Created by shiliang.wang on 15/2/6.
//  Copyright (c) 2015年 XOR. All rights reserved.
//

#import "SVCClassPaletteView.h"
#import "SVCPopoView.h"

#pragma mark ====== SVCBrushItem ======

#define UIViewAutoresizingAll (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin)

#define popoItemWidth 30
#define toolItemWidth 30


@interface SVCBrushItem : NSObject
@property (nonatomic) float width; // 宽度
@property (nonatomic) UIColor *color; // 颜色
@property (nonatomic) SVCBrushItemType type;  // 画笔类型 绘画,橡皮擦
@property (nonatomic,readonly) NSArray *points; // 点阵

+(SVCBrushItem*)defaultBrush;
+(SVCBrushItem*)brushWithType:(SVCBrushItemType)theType color:(UIColor*)theColor width:(float)theWidth points:(NSArray*)thePoints;

  // [NSValue valueWithCGPoint:thePoint]
-(void)addPoint:(CGPoint)thePoint;
-(void)addPoints:(NSArray*)thePoints;
@end

@implementation SVCBrushItem
{
  NSMutableArray *mPoints;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    mPoints = [NSMutableArray new];
    _width = 8;
    _color = [UIColor blackColor];
    _type = SVCBrushItemBrush;
  }
  return self;
}

+(SVCBrushItem*)defaultBrush
{
  SVCBrushItem *item = [SVCBrushItem new];
  return item;
}

+(SVCBrushItem*)brushWithType:(SVCBrushItemType)theType color:(UIColor*)theColor width:(float)theWidth points:(NSArray*)thePoints
{
  SVCBrushItem *item = [SVCBrushItem new];
  item.type = theType;
  if (theType == SVCBrushItemEraser) {
    item.color = [UIColor clearColor];
  }else{
    item.color = theColor;
  }
  item.width = theWidth;
  if (thePoints.count) {
    [item addPoints:thePoints];
  }
  return item;
}

-(void)addPoints:(NSArray*)thePoints
{
  [mPoints addObjectsFromArray:thePoints];
}

-(void)addPoint:(CGPoint)thePoint
{
  [mPoints addObject:[NSValue valueWithCGPoint:thePoint]];
}

  // get
-(NSArray*)points
{
  return mPoints;
}

@end


@implementation SVCPaletteView
{
  NSMutableArray *mPaintLines; // 已画的笔画,单位是 BLBrushItem
  NSMutableArray *mUndoLines; // 撤销的笔画
  SVCBrushItem *mCurentBrush; // 当前画笔
  BOOL isUndoOpen;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self defaultNewDatas];
  }
  return self;
}

-(void)defaultNewDatas
{
  if (!mPaintLines) {
    mPaintLines = [NSMutableArray new];
  }
  if (!mUndoLines) {
    mUndoLines = [NSMutableArray new];
  }
//  self.backgroundColor = [UIColor clearColor];
  self.curWidth = 4;
  self.curColor = [UIColor blackColor];
  self.curType = SVCBrushItemBrush;
}
  // actions
-(void)undoLast
{
  if (mPaintLines.count>0) {
    [mUndoLines addObject:[mPaintLines lastObject]];
    [mPaintLines removeLastObject];
    [self setNeedsDisplay];
  }
}

-(void)redoLast
{
  if (mUndoLines.count>0) {
    [mPaintLines addObject:[mUndoLines lastObject]];
    [mUndoLines removeLastObject];
    [self setNeedsDisplay];
  }
}

-(void)clearAll
{
  [mPaintLines removeAllObjects];
  [mUndoLines removeAllObjects];
  [self setNeedsDisplay];
}

#pragma mark - 手指开始触屏开始 -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
  UITouch* touch = [touches anyObject];
  if (touch) {
      // 创建 touch
    [mUndoLines removeAllObjects]; // 清除悔退的笔画
    mCurentBrush = [SVCBrushItem brushWithType:self.curType color:self.curColor width:self.curWidth points:nil];
    [mCurentBrush addPoint:[touch locationInView:self]];
    if (!mPaintLines) {
      mPaintLines = [NSMutableArray new];
    }
    [mPaintLines addObject:mCurentBrush];
  }
	NSLog(@"--- touchesBegan touchs:%lu ,hold touch:%lu ---",(unsigned long)touches.count,(unsigned long)touch.hash);
}
  //手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch* touch = [touches anyObject];
  CGPoint cPoint = [touch locationInView:self];
  CGPoint pPoint = [touch previousLocationInView:self];
  [mCurentBrush addPoint:cPoint];
  NSLog(@"--- touchesMoved point:%@ , pre:%@ ---",NSStringFromCGPoint(cPoint),NSStringFromCGPoint(pPoint));
	[self setNeedsDisplay];
}
  //当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (mCurentBrush.points.count<2) {
    [mPaintLines removeObject:mCurentBrush];
  }
  NSLog(@"--- touchesEnded touchPoints:%lu ---",(unsigned long)mCurentBrush.points.count);
	[self setNeedsDisplay];
}
  //电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (mCurentBrush.points.count<2) {
    [mPaintLines removeObject:mCurentBrush];
  }
  NSLog(@"--- touchesCancelled touchPoints:%lu ---",(unsigned long)mCurentBrush.points.count);
  [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    //NSLog(@"Thes is drawRect ");
    //获取上下文
	CGContextRef context = UIGraphicsGetCurrentContext();
    //设置笔冒
	CGContextSetLineCap(context, kCGLineCapRound);
    //设置画线的连接处　拐点圆滑
	CGContextSetLineJoin(context, kCGLineJoinRound);

    //画线
  for (int i=0; i<[mPaintLines count]; i++){
    SVCBrushItem *tempBrush = mPaintLines[i];
    
    CGContextBeginPath(context);
    CGPoint myStartPoint=[[tempBrush.points firstObject] CGPointValue];
    CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
    
    for (int j=1; j<tempBrush.points.count; j++){
      CGPoint myEndPoint=[tempBrush.points[j] CGPointValue];
      CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
    }
      // BlendMode
    CGBlendMode blendMode = (tempBrush.type == SVCBrushItemEraser)?kCGBlendModeDestinationIn:kCGBlendModeNormal;
    CGContextSetStrokeColorWithColor(context, tempBrush.color.CGColor);
    CGContextSetBlendMode(context,blendMode);
//    CGContextSetFillColorWithColor (context,  segmentColor);
    CGContextSetLineWidth(context, tempBrush.width);
    CGContextStrokePath(context);
  }
}

@end

#pragma mark ====== SVCClassPaletteView ======
@interface SVCClassPaletteView()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation SVCClassPaletteView
{
//  SVCPaletteView *mPaletteView; // 绘画层
  UIImageView *mBgImageView;

    // tableView
  UIButton *headerView;
  UIButton *footView;
  
  NSArray *toolList; //tableCell data
  NSArray *colorList; // buttons
  NSArray *widthList; // buttons
//  NSArray *eraserList; // buttons
  SVCPopoView *currentSegmentView;
  
  CGRect toosViewFrame;
  CGSize toosContentSize;
  
  NSString *cellIdentifier;
  
  CGSize popoSizeMax;
  BOOL isInitView;
}

-(void)createDefaultData
{
  if (!isInitView) {
    cellIdentifier = @"NSStringCellIdentifier";
      // [UIImage imageNamed:@"ppt_palette_tool_header"],
    toolList = @[
                 [UIImage imageNamed:@"ppt_palette_tool_item1_resize"],
                 [UIImage imageNamed:@"ppt_palette_tool_item2_pen"],
                 [UIImage imageNamed:@"ppt_palette_tool_item3_color"],
                 [UIImage imageNamed:@"ppt_palette_tool_item4_eraser"],
                 [UIImage imageNamed:@"ppt_palette_tool_item5_undo"],
                 [UIImage imageNamed:@"ppt_palette_tool_item6_redo"],
                 [UIImage imageNamed:@"ppt_palette_tool_item7_share"],
                 [UIImage imageNamed:@"ppt_palette_tool_item8_save"],
                 [UIImage imageNamed:@"ppt_palette_tool_item9_delete"]
                 ];
    
    widthList = @[@"1.0",@"2.6",@"5.0",@"8.0",@"10",@"16"];
//    colorNameList = @[@"棕",@"红",@"黄",@"绿",@"蓝",@"紫",@"黑"];
    colorList = @[[UIColor brownColor],[UIColor redColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor blackColor]];
    
    headerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView setImage:[UIImage imageNamed:@"ppt_palette_tool_header"] forState:UIControlStateNormal];
    headerView.frame = CGRectMake(0, 0, toolItemWidth, toolItemWidth); // 54,46
    [headerView addTarget:self action:@selector(actionExtendToolsView:) forControlEvents:UIControlEventTouchUpInside];
    self.toolsView.tableHeaderView = headerView;
    
    footView = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView setImage:[UIImage imageNamed:@"ppt_palette_tool_foot"] forState:UIControlStateNormal];
    footView.frame = CGRectMake(0, 0, toolItemWidth,toolItemWidth); // 54,40
    [footView addTarget:self action:@selector(actionExtendToolsView:) forControlEvents:UIControlEventTouchUpInside];
    self.toolsView.tableFooterView = footView;
    
    toosViewFrame = self.toolsView.frame;
    toosContentSize = self.toolsView.contentSize;
    [self.paletteView defaultNewDatas];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.toolsView reloadData];
    CGRect frame = self.toolsView.frame;
    frame.size.width = toolItemWidth;
    if (self.toolsView.contentSize.height > self.bounds.size.height) {
      frame.size.height = self.bounds.size.height;
    }else{
      frame.size.height = self.toolsView.contentSize.height;
    }
    self.toolsView.frame = frame;
    
    popoSizeMax = CGSizeMake(self.frame.size.width-self.toolsView.frame.origin.x, self.frame.size.height);
    
    isInitView = YES;
  }else{
    if (mBgImageView) {
      mBgImageView.image = nil;
    }
    [self.paletteView clearAll];
  }
}

-(void)clearAll
{
  [self hideSegmentView];
  mBgImageView.image = nil;
  [self.paletteView clearAll];
}

-(void)addBgImage:(UIImage*)theImage
{
  if (!mBgImageView) {
    mBgImageView = [[UIImageView alloc] initWithFrame:self.paletteView.frame];
    mBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self insertSubview:mBgImageView belowSubview:self.paletteView];
  }
  mBgImageView.image = theImage;
}

  // 隐藏 工具条
-(IBAction)actionExtendToolsView:(id)sender
{
    // TODO: 暂时不隐藏工具条
//  [self showToolListView:NO];
}

  // ============ action list ============
  //显示/隐藏 工具条
-(void)showToolListView:(BOOL)isShow
{
  self.toolsView.hidden = !isShow;
  if ([self.delegate respondsToSelector:@selector(paletteViewToolsViewStatusChanged:)]) {
    [self.delegate paletteViewToolsViewStatusChanged:isShow];
  }
}

#pragma mark ============ UITableView delegate ============
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return toolList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ppt_palette_tool_bg"]];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.autoresizingMask = UIViewAutoresizingAll;
    imageView1.frame = cell.bounds;
    imageView1.tag = 1102;
    [cell addSubview:imageView1];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:toolList[indexPath.row]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.autoresizingMask = UIViewAutoresizingAll;
    imageView.frame = cell.bounds;
    imageView.tag = 1101;
    [cell addSubview:imageView];
  }
//  cell.imageView.image = [UIImage imageNamed:@"ppt_palette_tool_bg"];
  UIImageView *tempIV = (UIImageView*)[cell viewWithTag:1101];
  tempIV.image = toolList[indexPath.row];

  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return toolItemWidth;
//  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//    return 36;
//  }else{
//    return 48;
//  }
}

-(NSIndexPath*)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  UIImageView *tempIV = (UIImageView*)[cell viewWithTag:1102];
  tempIV.image = [UIImage imageNamed:@"ppt_palette_tool_bg"];
  return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  UIImageView *tempIV = (UIImageView*)[cell viewWithTag:1102];
  tempIV.image = [UIImage imageNamed:@"ppt_palette_tool_bg_selected"];

  CGPoint showP2 = (CGPoint){0,cell.frame.size.height/2};
  CGPoint showP = [cell convertPoint:showP2 toView:self];
  NSLog(@"--------- cell frame:%@ ,point:%@ convert point:%@ -----------",NSStringFromCGRect(cell.frame),NSStringFromCGPoint(showP2),NSStringFromCGPoint(showP));
  
  [self hideSegmentView];
  switch (indexPath.row) {
    case 0: // resize
    {
      [self resizePaletteView];
    } break; // 笔画
    case 1:
    {
      [self segmentWidth:showP];
    } break;
    case 2: // 颜色
    {
      [self segmentColor:showP];
    } break;
    case 3: // 橡皮
    {
      [self segmentWidthEraser:showP];
    } break;
    case 4: // 取消
    {
      [self.paletteView undoLast];
    } break;
    case 5: // 重做
    {
      [self.paletteView redoLast];
    } break;
    case 6: // 分享
    {
      [self sharePaletteView];
    } break;
    case 7: // 保存
    {
      [self savePaletteView];
    } break;
    case 8: // 删除
    {
      [self deletePaletteView];
    } break;
    default:
      break;
  }
  NSLog(@"------- %@ --------",indexPath);
}

  // ---------utils ------------
-(void)resizePaletteView
{
    // TODO: undo
  
  
}

-(void)deletePaletteView
{
  if ([self.delegate respondsToSelector:@selector(paletteViewTakeSnapshoot:forOpration:)]) {
    [self.delegate paletteViewTakeSnapshoot:[self takePaletteViewPhoto] forOpration:SVCPaletteOprationMoveToTrach];
  }
  [self.paletteView clearAll];
}

-(void)sharePaletteView
{
  if ([self.delegate respondsToSelector:@selector(paletteViewTakeSnapshoot:forOpration:)]) {
    [self.delegate paletteViewTakeSnapshoot:[self takePaletteViewPhoto] forOpration:SVCPaletteOprationSharePhoto];
  }
}

-(void)savePaletteView
{
  if ([self.delegate respondsToSelector:@selector(paletteViewTakeSnapshoot:forOpration:)]) {
    [self.delegate paletteViewTakeSnapshoot:[self takePaletteViewPhoto] forOpration:SVCPaletteOprationSavePhoto];
  }
}

-(UIImage*)takePaletteViewPhoto
{
  CGFloat tempalpha = self.toolsView.alpha;
  self.toolsView.alpha = 0;
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
  self.toolsView.alpha = tempalpha;
  return image;
}

-(void)takePhptoForBg
{
  if (!self.mViewController) {
    NSLog(@"--------- no base viewController ----------");
    return;
  }
    //指定图片来源
	UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    //判断如果摄像机不能用图片来源与图片库
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
	}
	UIImagePickerController *picker=[[UIImagePickerController alloc] init];
	picker.delegate=self;
    //前后摄像机
    //picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
	picker.allowsEditing=YES;
	picker.sourceType=sourceType;
  [self.mViewController presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:nil];
    //
	UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
//  [self addBgImage:image];
	[self performSelector:@selector(addBgImage:) withObject:image afterDelay:0.25];
}

  //按取消键时
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)segmentColor:(CGPoint)thePoint
{
  currentSegmentView = [[SVCPopoView alloc] init];
  [currentSegmentView showLeftPopoInView:self withPoint:thePoint withButtons:[self findColorSelectButtons] actionBack:^(id selectItem, NSInteger index) {
    self.paletteView.curColor = colorList[index];
    self.paletteView.curType = SVCBrushItemBrush;
  }];
}

-(void)segmentWidth:(CGPoint)thePoint
{
  currentSegmentView = [[SVCPopoView alloc] init];
  [currentSegmentView showLeftPopoInView:self withPoint:thePoint withButtons:[self findWidthSelectButtons] actionBack:^(id selectItem, NSInteger index) {
    self.paletteView.curWidth = [widthList[index] floatValue];
    self.paletteView.curType = SVCBrushItemBrush;
  }];
}

-(void)segmentWidthEraser:(CGPoint)thePoint
{
  currentSegmentView = [[SVCPopoView alloc] init];
  [currentSegmentView showLeftPopoInView:self withPoint:thePoint withButtons:[self findWidthSelectButtons] actionBack:^(id selectItem, NSInteger index) {
    self.paletteView.curWidth = [widthList[index] floatValue];
    self.paletteView.curType = SVCBrushItemEraser;
  }];
}

-(CGRect)findSegmentItemFrame
{
  float width = popoItemWidth;
  return CGRectMake(0, 0, width, width);
}

-(NSArray*)findColorSelectButtons
{
  NSMutableArray *buttons = [NSMutableArray new];
  CGRect tempFrame = [self findSegmentItemFrame];
  for (UIColor *tempColor in colorList) {
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempButton.frame = tempFrame;
    tempButton.backgroundColor = tempColor;
    [buttons addObject:tempButton];
  }
  return buttons;
}

-(NSArray*)findWidthSelectButtons
{
  NSMutableArray *buttons = [NSMutableArray new];
  CGRect tempFrame = [self findSegmentItemFrame];
  for (NSString *tempStr in widthList) {
    UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
    tempButton.titleLabel.font = [UIFont systemFontOfSize:15];
    tempButton.backgroundColor = [UIColor grayColor];
//    tempButton.titleLabel.text = tempStr;
//    tempButton.titleLabel.textColor = [UIColor blueColor];
    [tempButton setTitle:tempStr forState:UIControlStateNormal];
    [buttons addObject:tempButton];
  }
  return buttons;
}

-(void)hideSegmentView
{
  if (currentSegmentView) {
    [currentSegmentView removeFromSuperview];
    currentSegmentView = nil;
  }
}

@end

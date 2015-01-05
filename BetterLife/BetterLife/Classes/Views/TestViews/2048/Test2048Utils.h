//
//  Test@048Utils.h
//  BetterLife
//
//  Created by shiliang.wang on 14/12/22.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>


struct Test2048ItemTable {
  int row;
  int col;
};
typedef struct Test2048ItemTable Test2048ItemTable;

#define titleBtnStartNormal     @"开始"
#define titleBtnStartReStart    @"重新开始"
#define titleBtnUndoNormal      @"上一步"
#define titleBtnSettings        @"设置"
#define titlescoreNumberNow     @"本局分数"
#define titleScoreNumberTall    @"最高分数"




@interface Test2048Utils : NSObject
@property (nonatomic) int gameColorType;

+(instancetype)sharedObject;

-(UIColor*)findBodyItemBgColor;

-(int)findItemNextNumber;
-(UIColor*)findItemTextColor:(int)theNumber;
-(UIColor*)findItemBgColor:(int)theNumber;

-(NSString*)findItemShowNumber:(int)theNumber;
-(void)printBodyViews:(NSArray*)theItemViews rowNumber:(int)theNum;


@end

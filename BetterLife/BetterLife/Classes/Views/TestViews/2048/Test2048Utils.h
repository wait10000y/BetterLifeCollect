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

struct test2048MoveResult {
  BOOL hasMoved;
  int score;
};typedef struct test2048MoveResult test2048MoveResult;


#define titleBtnStartNormal     @"开始"
#define titleBtnStartReStart    @"重新开始"
#define titleBtnUndoNormal      @"上一步"
#define titleBtnSettings        @"设置"
#define titlescoreNumberNow     @"本局分数"
#define titleScoreNumberTall    @"最高分数"

#define itemViewAnimateDuration 0.1f

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

#pragma mark --- interface Test2048RecordItem ---
@interface Test2048RecordItem : NSObject
@property (nonatomic) int index;
@property (nonatomic) NSArray *bodyDatas;
@property (nonatomic) int scrose;

+(id)recordWithDatas:(NSArray *)theDatas scrose:(int)theScrose;


@end
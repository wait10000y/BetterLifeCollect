//
//  Test@048Utils.m
//  BetterLife
//
//  Created by shiliang.wang on 14/12/22.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "Test2048Utils.h"


@implementation Test2048RecordItem

+(id)recordWithDatas:(NSArray *)theDatas scrose:(int)theScrose
{
  Test2048RecordItem *temp = [Test2048RecordItem new];
  temp.bodyDatas = theDatas;
  temp.scrose = theScrose;
  return temp;
}

@end


@implementation Test2048Utils

@end

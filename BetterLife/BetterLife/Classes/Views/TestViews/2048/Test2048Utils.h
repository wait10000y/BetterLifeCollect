//
//  Test@048Utils.h
//  BetterLife
//
//  Created by shiliang.wang on 14/12/22.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Test2048RecordItem : NSObject
@property (nonatomic) int index;
@property (nonatomic) NSArray *bodyDatas;
@property (nonatomic) int scrose;

+(id)recordWithDatas:(NSArray *)theDatas scrose:(int)theScrose;


@end


@interface Test2048Utils : NSObject



@end

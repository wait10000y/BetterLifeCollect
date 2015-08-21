//
//  DCBallMainViewController.h
//  BetterLife
//
//  Created by shiliang.wang on 15/1/5.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"

/*
  1.
 2. 显示最新列表
 3. 随机一组,5组,n组
 
 4. 统计分析:
 a. 导入历史数据(指定服务器更新)
 b. 按类别分析(指定范围,指定类别)
 c. 设定干扰值,随机n组数据
 
 5. 提交分享
 
 */


typedef enum : NSUInteger {
  PlayingType_shuangseqiu = 0,
  PlayingType_daletou = 1,
  PlayingType_custom = 2
} PlayingType;


@interface DCBallMainViewController : BaseDefineViewController



@end

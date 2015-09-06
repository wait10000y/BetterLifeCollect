//
//  PLifeMainViewController.h
//  BetterLife
//
//  Created by shiliang.wang on 15/1/5.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//
/*
 1. 功能类别列表
 2. 功能详情页面
 3. 功能操作界面
 4. 内容展示界面
 5. 其他分享
 
 */

#import "BaseDefineViewController.h"

@interface PLifeMainViewController : BaseDefineViewController
@property (weak, nonatomic) IBOutlet UITextView *textShow;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UILabel *textDate;


- (IBAction)actionStart:(UIButton *)sender;

@end

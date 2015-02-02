//
//  TestDownload2ViewController.h
//  BetterLife
//
//  Created by shiliang.wang on 15/1/13.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"

@interface TestDownload2ViewController : BaseDefineViewController

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UITextView *textShow;
@property (weak, nonatomic) IBOutlet UIImageView *imageShow;

-(IBAction)actionStartOperation:(UIButton*)sender;


@end

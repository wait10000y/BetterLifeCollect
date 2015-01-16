//
//  SIDLownloadTestViewController.h
//  BetterLife
//
//  Created by shiliang.wang on 15/1/9.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "BaseDefineViewController.h"
#import "SIDownloadManager.h"
#import "SIBreakpointsDownload.h"

@interface SIDLownloadTestViewController : BaseDefineViewController<SIDownloadManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonDownloadOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteOne;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusOne;
@property (weak, nonatomic) IBOutlet UIProgressView *progressViewOne;

@property (weak, nonatomic) IBOutlet UIButton *buttonDownloadTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusTwo;
@property (weak, nonatomic) IBOutlet UIProgressView *progressViewTwo;


- (IBAction)downloadOneAction:(id)sender;
- (IBAction)pauseOneAction:(id)sender;
- (IBAction)deleteOneAction:(id)sender;

- (IBAction)downloadTwoAction:(id)sender;
- (IBAction)pauseTwoAction:(id)sender;
- (IBAction)deleteTwoAction:(id)sender;

-(IBAction)actionShowOthers:(id)sender;

@end

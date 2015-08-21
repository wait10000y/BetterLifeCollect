//
//  TestFontListViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/3/2.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestFontListViewController.h"

@interface TestFontListViewController ()

@end

@implementation TestFontListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  int count = 0;
  for (NSString* tempName in [UIFont familyNames]) {
    count += [UIFont fontNamesForFamilyName:tempName].count;
  }
  
  NSLog(@"---- all font size:%d -----",count);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //字体家族总数
  
  return [[UIFont familyNames] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //字体家族包括的字体库总数
  return [[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:section] ] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //字体家族名称
  NSString * fontName = [[UIFont familyNames] objectAtIndex:section];
  if([fontName isEqualToString:@"Menlo Regular"]||[fontName isEqualToString:@"Menlo Bold"]||[fontName isEqualToString:@"Zapf Dingbats"] ){
    NSLog(@"%@",fontName);
  }
  return [[UIFont familyNames] objectAtIndex:section];
}



- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
  [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
  return index;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
  }
  
    // Configure the cell.
  cell.textLabel.textColor = indexPath.row %2 ? [UIColor greenColor] : [UIColor magentaColor];
  
    //字体家族名称
  NSString *familyName= [[UIFont familyNames] objectAtIndex:indexPath.section];
    //字体家族中的字体库名称
  NSString *fontName  = [[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  
  cell.textLabel.font = [UIFont fontWithName:fontName size:14.0f];
  
    //查找微软雅黑字体Zapf Dingbats
  if([fontName isEqualToString:@"Menlo Regular"]||[fontName isEqualToString:@"Menlo Bold"]||[fontName isEqualToString:@"Zapf Dingbats"] ){
    NSLog(@"%@",fontName);
  }
  cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", familyName, fontName ];
  
  return cell;
  
}

-(void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath{
  
  NSLog(@"--- accessoryButtonTapped %ld-%ld ---",(long)indexPath.section,(long)indexPath.row);
  
}

@end

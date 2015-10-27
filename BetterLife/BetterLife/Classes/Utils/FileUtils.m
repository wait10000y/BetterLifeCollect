//
//  FileUtils.m
//  BetterLife
//
//  Created by wsliang on 15/10/10.
//  Copyright © 2015年 wsliang. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils


//NSFileHandle获取出路文件的手柄
//
//NSFileManager处理文件的（创建、删除等）
//
//第一个实例：追加数据
-(void)fileAppendData:(NSData*)theData
{
  if (theData.length == 0) { return; }
  NSString *homePath = NSHomeDirectory();
  NSString *filePath = [homePath stringByAppendingPathComponent:@"phone/nsfile_test_data.txt"];
  NSLog(@"file path = %@",filePath);
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
  [fileHandle seekToEndOfFile];
  
  [fileHandle writeData:theData];
  [fileHandle closeFile];
}

//第二个实例：追加数据到指定的位置
-(void)fileAppendData:(NSData*)theData offset:(unsigned long long)offset
{
  NSString *homePath = NSHomeDirectory();
  NSString *filePath = [homePath stringByAppendingPathComponent:@"phone/nsfile_test_data.txt"];
  NSLog(@"file path = %@",filePath);
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
  
  [fileHandle seekToFileOffset:offset];
  [fileHandle writeData:theData];
  [fileHandle closeFile];
  
}

//第三个实例：定位读取数据
-(NSData*)fileReadDataWithRange:(NSRange)theRange
{
  NSString *homePath = NSHomeDirectory();
  NSString *filepath = [homePath stringByAppendingPathComponent:@"phone/nsfile_test_data.txt"];
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filepath];
  NSUInteger length = [[fileHandle availableData] length];
  if (length > theRange.location) {
    [fileHandle seekToFileOffset:theRange.location];
    NSUInteger oLength = (length-theRange.location)>=theRange.length?theRange.length:(length-theRange.location);
    NSData *data = [fileHandle readDataOfLength:oLength];
    return data;
  }
  return [NSData new];
  //  NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  //  NSLog(@"str = %@",str);
  
}

//第四个实例：复制文件
-(BOOL)fileCopy
{
  NSString *homepath = NSHomeDirectory();
  NSString *sourcepath  = [homepath stringByAppendingPathComponent:@"phone/nsfile_test_data.txt"];
  NSString *targetpath = [homepath stringByAppendingPathComponent:@"phone/nsfile_test_data_bak.txt"];
  
  NSFileManager *manager = [NSFileManager defaultManager];
  BOOL success = [manager createFileAtPath:targetpath contents:nil attributes:nil];
  if(success)
  {
    NSLog(@"创建目标文件成功");
    NSFileHandle *outfile = [NSFileHandle fileHandleForReadingAtPath:sourcepath];
    NSFileHandle *infile = [NSFileHandle fileHandleForWritingAtPath:targetpath];
    //    NSUInteger length = [[outfile availableData] length];
    //    if (length > 8*1024*1024) {
    //      // 分块 复制
    //    }
    NSData *outdata = [outfile readDataToEndOfFile];
    
    [infile writeData:outdata];
    
    [infile closeFile];
    [outfile closeFile];
    return YES;
  }else{
    NSLog(@"无法创建目标文件");
  }
  return NO;
}




@end

//
//  TestDownload2ViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 15/1/13.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestDownload2ViewController.h"
#import "SIDLownloadTestViewController.h"
#import "MKNetworkKit.h"
#import "UIImageView+MKNetworkKitAdditions.h"

#import "DDLogCommon.h"
static const int ddLogLevel = LOGLEVEL_TestMKNetworkKit;

@interface TestDownload2ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation TestDownload2ViewController
{
  NSArray *mOpreationArray;
  NSInteger mSelectIndex;
  NSMutableString *mCacheString;
  
  MKNetworkEngine *mNormalEngine;
  
  MKNetworkEngine *mAuthEngine;
  MKNetworkEngine *mHttpsEngine;
  
  
  
}
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
  self.imageShow.hidden = YES;
  mSelectIndex = 0;
  mCacheString = [[NSMutableString alloc] init];
  self.textShow.layer.borderWidth = 1;
  self.textShow.layer.borderColor = [UIColor lightGrayColor].CGColor;
  
  mOpreationArray = @[
                      @"测试get",
                      @"测试图片下载",
                      @"测试大文件下载",
                      @"测试流形式下载",
                      @"测试post请求",
                      @"测试上传文件",
                      @"测试上传大文件",
                      @"测试上传流数据",
                      @"-测试断点下载-"
                      ];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- delegate ----
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}
  // returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return mOpreationArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return mOpreationArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  mSelectIndex = row;
}


-(IBAction)actionStartOperation:(UIButton*)sender
{
  [self clearMessage];
  switch (mSelectIndex) {
    case 0:
    {
      [self demoTestGet];
    }break;
    case 1:
    {
      [self demoTestDownloadImage];
    }break;
    case 2:
    {
      [self demoTestDownloadbigFile];
    }break;
    case 3:
    {
      [self demoTestDownloadStream];
    }break;
    case 4:
    {
      [self demoTestPostSimple];
    }break;
    case 5:
    {
      [self demoTestUploadFile];
    }break;
    case 6:
    {
      [self demoTestUploadBigFile];
    }break;
    case 7:
    {
      [self demoTestUploadStream];
    }break;
    case 8:
    {
      SIDLownloadTestViewController *sidVC = [SIDLownloadTestViewController loadNibViewController:nil];
      [self.navigationController pushViewController:sidVC animated:YES];
    }break;
      
    default:
      break;
  }
  
}
  // ----------- actions ------------
  // http://www.baidu.com/img/bdlogo.png
  // http://www.baidu.com/img/baidu_jgylogo3.gif
-(void)demoTestGet
{
  if (mNormalEngine) {
    [self createNormalEngine];
  }
  MKNetworkOperation *tempOperation = [mNormalEngine operationWithPath:@"img/baidu_jgylogo3.gif"];
  
  [tempOperation onDownloadProgressChanged:^(double progress) {
    [self showMessage:[NSString stringWithFormat:@"TestGet download progress:%f",progress]];
  }];
  
  [tempOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    [self showMessage:[NSString stringWithFormat:@"TestGet operation complete [%@]",completedOperation]];
    NSData *resData = [completedOperation responseData];
    [self showMessage:[NSString stringWithFormat:@"TestGet resData length:%lu",(unsigned long)resData.length]];
    
  } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    [self showMessage:[NSString stringWithFormat:@"TestGet operation complete with error:%@,[%@]",completedOperation,error]];
    NSData *resData = [completedOperation responseData];
    [self showMessage:[NSString stringWithFormat:@"TestGet resData length:%lu",(unsigned long)resData.length]];
  }];
  
  [tempOperation onNotModified:^{
    [self showMessage:[NSString stringWithFormat:@"TestGet 304 error "]];
  }];
  
  [self showMessage:[NSString stringWithFormat:@"TestGet start operation:%@",tempOperation]];
  [mNormalEngine enqueueOperation:tempOperation];
//  [tempOperation start];
  
}


-(void)demoTestPostSimple
{
  
}

-(void)demoTestUploadStream
{
  
}

-(void)demoTestUploadBigFile
{
  
}

-(void)demoTestUploadFile
{
  
}


-(void)demoTestDownloadStream
{
  
}

-(void)demoTestDownloadbigFile
{
  
}

  // --------------- ======================= --------------

-(MKNetworkEngine*)createNormalEngine
{
  mNormalEngine = [[MKNetworkEngine alloc] initWithHostName:@"www.baidu.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
  return mNormalEngine;
}
-(MKNetworkEngine*)createAuthEngine
{
  mAuthEngine = [[MKNetworkEngine alloc] initWithHostName:@"testbed2.mknetworkkit.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
  return mAuthEngine;
}

-(MKNetworkEngine*)createHttpsEngine
{
  mHttpsEngine = [[MKNetworkEngine alloc] initWithHostName:@"testbed1.mknetworkkit.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
  return mHttpsEngine;
}

-(void)testBasicAuth
{
  if (!mAuthEngine) {
    [self createAuthEngine];
  }
  
  MKNetworkOperation *op = [mAuthEngine operationWithPath:@"basic_auth.php"
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op setUsername:@"admin" password:@"password" basicAuth:YES];
  
  [op addCompletionHandler:^(MKNetworkOperation *operation) {
    
    DLog(@"%@", [operation responseString]);
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    
    DLog(@"%@", [error localizedDescription]);
  }];
  [mAuthEngine enqueueOperation:op];
}

-(void)testDigestAuth
{
  if (!mAuthEngine) {
    [self createAuthEngine];
  }
  MKNetworkOperation *op = [mAuthEngine operationWithPath:@"digest_auth.php" params:nil httpMethod:@"GET"];
  [op setUsername:@"admin" password:@"password"];
  [op setCredentialPersistence:NSURLCredentialPersistenceNone];
  
  [op addCompletionHandler:^(MKNetworkOperation *operation) {
    if (operation.isCachedResponse) {
        // user cache data ...
    }
    DLog(@"%@", [operation responseString]);
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    DLog(@"%@", [error localizedDescription]);
  }];
  [mAuthEngine enqueueOperation:op];
}

  // 富媒体
-(void)testDownloadFatAssFile
{
  if (!mAuthEngine) {
    [self createAuthEngine];
  }
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = paths[0];
	NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"DownloadedFile.pdf"];
  
  MKNetworkOperation *op = [mAuthEngine operationWithURLString:@"http://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/NSURLRequest_Class.pdf"];
  [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:downloadPath append:YES]];
  [op onDownloadProgressChanged:^(double progress) {
    DLog(@"%.2f", progress*100.0);
  }];
  
  [op addCompletionHandler:^(MKNetworkOperation* completedRequest) {
    DLog(@"%@", completedRequest);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Completed"
                                                    message:@"The file is in your Caches directory"
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                          otherButtonTitles:nil];
    [alert show];
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                DLog(@"%@", error);
                [UIAlertView showWithError:error];
              }];
  
  [mAuthEngine enqueueOperation:op];
}

-(void)testUploadImageFromFile
{
  if (!mAuthEngine) {
    [self createAuthEngine];
  }
  MKNetworkOperation *op = [mAuthEngine operationWithPath:@"upload.php"
                                            params:@{@"Submit": @"YES"}
                                        httpMethod:@"POST"];
  
  NSString *uploadPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/SampleImage.jpg"];
  [op addFile:uploadPath forKey:@"image"];
  
    // setFreezable uploads your images after connection is restored!
  [op setFreezable:YES];
  
  [op onUploadProgressChanged:^(double progress) {
    DLog(@"%.2f", progress*100.0);
  }];
  
  
  [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
    NSString *xmlString = [completedOperation responseString];
    DLog(@"%@", xmlString);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded to"
                                                    message:(NSString*) xmlString
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                          otherButtonTitles:nil];
    [alert show];
    
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    [UIAlertView showWithError:error];
              }];
  
  [mAuthEngine enqueueOperation:op];
}

-(void)testServerTrust
{
  if (!mHttpsEngine) {
    [self createHttpsEngine];
  }
  
  MKNetworkOperation *op = [mHttpsEngine operationWithPath:@"/" params:nil httpMethod:nil ssl:YES];
  
  [op addCompletionHandler:^(MKNetworkOperation *operation) {
    DLog(@"%@", [operation responseString]);
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    
    DLog(@"%@", [error localizedDescription]);
  }];
  [mHttpsEngine enqueueOperation:op];
}

-(void)testClientCert
{
  if (!mHttpsEngine) {
    [self createHttpsEngine];
  }
  MKNetworkOperation *op = [mHttpsEngine operationWithPath:@"/" params:nil httpMethod:nil ssl:YES];
  op.clientCertificate = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"client.p12"];
  op.clientCertificatePassword = @"test";
  
  [op addCompletionHandler:^(MKNetworkOperation *operation) {
    
    DLog(@"%@", [operation responseString]);
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    
    DLog(@"%@", [error localizedDescription]);
  }];
  [mHttpsEngine enqueueOperation:op];
}

-(void)testShowImage
{
  self.imageShow.hidden = NO;
  [self.imageShow setImageFromURL:[NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"] placeHolderImage:nil];
}

  // --------------- ======================= --------------
-(void)demoTestDownloadImage
{
  if (mNormalEngine) {
    [self createNormalEngine];
  }
  mNormalEngine = [[MKNetworkEngine alloc] initWithHostName:@"www.baidu.com"];
    // test 1
  [mNormalEngine
   imageAtURL:[NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"]
   size:CGSizeMake(200, 140)
   completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
     [self showMessage:[NSString stringWithFormat:@"--- DownloadImage imageAtURL complete:image:%@,url:%@,isInCache:%d",NSStringFromCGSize(fetchedImage.size),url,isInCache]];
  } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    [self showMessage:[NSString stringWithFormat:@"--- DownloadImage imageAtURL complete error:%@",error]];
  }];
  
    // test 2
  MKNetworkOperation *tempOperation = [mNormalEngine operationWithPath:@"img/bdlogo.png" params:nil httpMethod:@"get" ssl:NO];
  [tempOperation onDownloadProgressChanged:^(double progress) {
    [self showMessage:[NSString stringWithFormat:@"----- DownloadImage download progress:%f -----",progress]];
  }];
  
  [tempOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    [self showMessage:[NSString stringWithFormat:@"operation complete [%@]",completedOperation]];
    NSData *resData = [completedOperation responseData];
    [self showMessage:[NSString stringWithFormat:@"--- DownloadImage resData length:%lu ---",(unsigned long)resData.length]];
    
  } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    DDLogWarn(@"operation complete with error:%@,[%@]",completedOperation,error);
    NSData *resData = [completedOperation responseData];
    [self showMessage:[NSString stringWithFormat:@"--- DownloadImage resData length:%lu ---",(unsigned long)resData.length]];
  }];
  
  [tempOperation onNotModified:^{
    [self showMessage:[NSString stringWithFormat:@"---- DownloadImage 304 error ----"]];
  }];
  [self showMessage:[NSString stringWithFormat:@"------ DownloadImage start operation:%@ -------",tempOperation]];
//  [tempOperation start];
  [mNormalEngine enqueueOperation:tempOperation];
}

  // ------- utils --------

-(void)showMessage:(NSString*)theMsg
{
  DDLogInfo(@"--- showMessage:%@ ---",theMsg);
  [mCacheString appendFormat:@"\n[%@]",[[NSDate date] description]];
  [mCacheString appendString:theMsg];
  self.textShow.text = mCacheString;
  float height = self.textShow.contentSize.height-self.textShow.bounds.size.height;
  if (height>0) {
    self.textShow.contentOffset = CGPointMake(0,height);
  }
}

-(void)clearMessage
{
  DDLogInfo(@"--- clearMessage ---");
  mCacheString = [NSMutableString new];
  self.textShow.text = @"";
}

-(void)showImage:(UIImage*)theImage
{
  DDLogInfo(@"--- showImage:%@ ---",NSStringFromCGSize(theImage.size));
  self.imageShow.hidden = NO;
  self.imageShow.image = theImage;
  [UIView animateWithDuration:4 animations:nil completion:^(BOOL finished) {
    self.imageShow.hidden = YES;
  }];
}

@end

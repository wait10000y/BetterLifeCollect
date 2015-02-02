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


#define downloadFileUrlString @"http://www.baidu.com/img/bdlogo.png"
#define downloadFileUrlString2 @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.1.0.dmg"



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
                      @"--- 选择 ---",
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
  
  
  @try {
    NSAssert1((1==0), @"1==0", nil);
  }
  @catch (NSException *exception) {
    NSLog(@"------- @catch :%@ --------",exception);
  }
  @finally {
    NSLog(@"------- @finally --------");
  }
  
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
    case 1:
    {
      [self demoTestGet];
    }break;
    case 2:
    {
      [self demoTestDownloadImage];
    }break;
    case 3:
    {
      [self demoTestDownloadbigFile];
    }break;
    case 4:
    {
      [self demoTestDownloadFileByPartly];
    }break;
    case 5:
    {
      [self demoTestPostSimple];
    }break;
    case 6:
    {
      [self demoTestUploadFile];
    }break;
    case 7:
    {
      [self demoTestUploadBigFile];
    }break;
    case 8:
    {
      [self demoTestUploadStream];
    }break;
    case 9:
    {
      SIDLownloadTestViewController *sidVC = [SIDLownloadTestViewController loadNibViewController:nil];
      [self.navigationController pushViewController:sidVC animated:YES];
    }break;
      
    default:
      break;
  }
  
}
  // ----------- actions ------------
  /*
   http://www.baidu.com/img/bdlogo.png
   http://www.baidu.com/img/baidu_jgylogo3.gif
   */
-(void)demoTestGet
{
  if (!mNormalEngine) {
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

-(void)demoTestDownloadImage
{
  if (!mNormalEngine) {
    [self createNormalEngine];
  }
  if (1) {
      // test 1
    [mNormalEngine
     imageAtURL:[NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"]
     size:CGSizeMake(200, 140)
     completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
       [self showMessage:[NSString stringWithFormat:@"--- DownloadImage imageAtURL complete:image:%@,url:%@,isInCache:%d",NSStringFromCGSize(fetchedImage.size),url,isInCache]];
       [self showImage:fetchedImage];
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
       [self showMessage:[NSString stringWithFormat:@"--- DownloadImage imageAtURL complete error:%@",error]];
     }];
    
  }else{
      // test 2
    MKNetworkOperation *tempOperation = [mNormalEngine operationWithPath:@"img/bdlogo.png" params:nil httpMethod:@"get" ssl:NO];
    [tempOperation onDownloadProgressChanged:^(double progress) {
      [self showMessage:[NSString stringWithFormat:@"----- DownloadImage download progress:%f -----",progress]];
    }];
    
    [tempOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
      mNormalEngine = nil;
      [self showMessage:[NSString stringWithFormat:@"operation complete [%@]",completedOperation]];
      NSData *resData = [completedOperation responseData];
      [self showMessage:[NSString stringWithFormat:@"--- DownloadImage resData length:%lu ---",(unsigned long)resData.length]];
      
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
      mNormalEngine = nil;
      DDLogWarn(@"operation complete with error:%@,[%@]",completedOperation,error);
      NSData *resData = [completedOperation responseData];
      [self showMessage:[NSString stringWithFormat:@"--- DownloadImage resData length:%lu ---",(unsigned long)resData.length]];
    }];
    
    [tempOperation onNotModified:^{
      mNormalEngine = nil;
      [self showMessage:[NSString stringWithFormat:@"---- DownloadImage 304 error ----"]];
    }];
    [self showMessage:[NSString stringWithFormat:@"------ DownloadImage start operation:%@ -------",tempOperation]];
      //  [tempOperation start];
    [mNormalEngine enqueueOperation:tempOperation];
  }
}

/*!
 *  下载大文件时,设置文件缓存位置,使用 NSOutputStream outputStreamToFileAtPath:
 文件下载完成后,后续处理
 */
-(void)demoTestDownloadbigFile
{
  NSString *urlPdf = downloadFileUrlString;
  if (!mNormalEngine) {
    [self createNormalEngine];
  }
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = paths[0];
	NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"DownloadedFile.png"];
  
  MKNetworkOperation *op = [mNormalEngine operationWithURLString:urlPdf];
  NSOutputStream *tempOut = [NSOutputStream outputStreamToFileAtPath:downloadPath append:NO];
//  tempOut.delegate = self;
  [op addDownloadStream:tempOut];
  [op onDownloadProgressChanged:^(double progress) {
    [self showMessage:[NSString stringWithFormat:@"%.2f",progress*100]];
  }];
  
  [op addCompletionHandler:^(MKNetworkOperation* completedRequest) {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:downloadPath]) {
      NSDictionary *attr = [fm attributesOfItemAtPath:downloadPath error:nil];
      NSString *compStr = [NSString stringWithFormat:@"Download file Completed,data:[%@] file:%@",[completedRequest responseData],attr];
      DDLogInfo(@"--- %@ ---",compStr);
      [self showMessage:compStr];
    }
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    [self showMessage:[error description]];
//    [UIAlertView showWithError:error];
  }];
  
  [mNormalEngine enqueueOperation:op];
  
}


-(void)demoTestDownloadFileByPartly
{
  NSString *urlPdf = downloadFileUrlString;
  
  if (!mNormalEngine) {
    [self createNormalEngine];
  }

  MKNetworkOperation *op = [mNormalEngine operationWithURLString:urlPdf];

  [op onDownloadProgressChanged:^(double progress) {
    [self showMessage:[NSString stringWithFormat:@"%.2f",progress*100]];
  }];
  

  
  [op addCompletionHandler:^(MKNetworkOperation* completedRequest) {
    [self showMessage:[NSString stringWithFormat:@"Download Completed length:%lu",[completedRequest responseData].length]];
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    [self showMessage:[error description]];
  }];
  
  [mNormalEngine enqueueOperation:op];
}


  // ------------------------------------


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

  dispatch_async(dispatch_get_main_queue(), ^{
    self.imageShow.hidden = NO;
    self.imageShow.image = theImage;
    [UIView animateWithDuration:4 animations:nil completion:^(BOOL finished) {
      self.imageShow.hidden = YES;
    }];
  });
  
}

@end

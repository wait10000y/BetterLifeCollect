//
//  StanObject.m
//  testAVSpeech
//
//  Created by shiliang.wang on 14-8-1.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "SystemInfoObject.h"

#include <mach/task_info.h>
#include <mach/thread_info.h>
#include <mach/mach_types.h>

#include <libkern/OSAtomic.h>
#include <execinfo.h>
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t   UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

void MySignalHandler(int signal) {
  int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
  if (exceptionCount > UncaughtExceptionMaximum) { return; }
  
  NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
  NSArray *callStack = [SystemInfoObject backtrace];
  [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
  
  NSException *tempEx = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n", nil),signal]
                                              userInfo:userInfo];
  [[[SystemInfoObject alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:tempEx waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(NSException *exception) {
    //获取异常信息
  if (exception) {
    [[[SystemInfoObject alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
  }else{
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);
  }
}


#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;
@implementation SystemInfoObject

+(SystemInfoObject*)shareObject
{
  static SystemInfoObject *staticObject;
  static dispatch_once_t onceIndex;
  dispatch_once(&onceIndex, ^{
    staticObject = [SystemInfoObject new];
  });
  return staticObject;
}

/*
SUserName(void);
NSFullUserName(void);
NSHomeDirectory(void);
NSHomeDirectoryForUser(NSString *userName);
NSTemporaryDirectory(void);
NSOpenStepRootDirectory(void);
 */

+ (NSString *) getDocumentsDirectory
{
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (float)cpu_usage
{
  return 0;
//	kern_return_t			kr = { 0 };
//	task_info_data_t		tinfo = { 0 };
//	mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
//  
//	kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
//	if ( KERN_SUCCESS != kr )
//		return 0.0f;
//  
//	task_basic_info_t		basic_info = { 0 };
//	thread_array_t			thread_list = { 0 };
//	mach_msg_type_number_t	thread_count = { 0 };
//  
//	thread_info_data_t		thinfo = { 0 };
//	thread_basic_info_t		basic_info_th = { 0 };
//  
//	basic_info = (task_basic_info_t)tinfo;
//  
//    // get threads in the task
//	kr = task_threads( mach_task_self(), &thread_list, &thread_count );
//	if ( KERN_SUCCESS != kr )
//		return 0.0f;
//  
//	long	tot_sec = 0;
//	long	tot_usec = 0;
//	float	tot_cpu = 0;
//  
//	for ( int i = 0; i < thread_count; i++ )
// 	{
// 		mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
//    
// 		kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
// 		if ( KERN_SUCCESS != kr )
// 			return 0.0f;
//    
//		basic_info_th = (thread_basic_info_t)thinfo;
// 		if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
//		{
//			tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
//			tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
//			tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
//		}
//	}
//  
//	kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
//	if ( KERN_SUCCESS != kr )
//		return 0.0f;
//  
//	return tot_cpu;
}

+ (NSString *) getMacaddress
{
  int                 mib[6];
  size_t              len;
  char                *buf;
  unsigned char       *ptr;
  struct if_msghdr    *ifm;
  struct sockaddr_dl  *sdl;
  
  mib[0] = CTL_NET;
  mib[1] = AF_ROUTE;
  mib[2] = 0;
  mib[3] = AF_LINK;
  mib[4] = NET_RT_IFLIST;
  
  if ((mib[5] = if_nametoindex("en0")) == 0) {
    printf("Error: if_nametoindex error\n");
    return NULL;
  }
  
  if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 1\n");
    return NULL;
  }
  
  if ((buf = malloc(len)) == NULL) {
    printf("Error: Memory allocation error\n");
    return NULL;
  }
  
  if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 2\n");
    free(buf); // Thanks, Remy "Psy" Demerest
    return NULL;
  }
  
  ifm = (struct if_msghdr *)buf;
  sdl = (struct sockaddr_dl *)(ifm + 1);
  ptr = (unsigned char *)LLADDR(sdl);
  NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
  
  free(buf);
  return outstring;
}

+ (NSString *) getAppInfo
{
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"]; // app名称
  NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"]; // app版本
  NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"]; // app build版本
//  NSString *deviceMac = [SystemInfoObject getMacaddress]; // mac 地址
  NSString *appFold = [infoDictionary valueForKey:@"CFBundleInfoPlistURL"];
//  NSArray *folders = [appFold componentsSeparatedByString:@"/"];
//  if (folders.count>5) {
//    appFold = folders[4];
//  }else{
//    appFold = [folders lastObject];
//  }
  /*
   [NSProcessInfo processInfo].globallyUniqueString,
   [UIDevice currentDevice].identifierForVendor,
   [UIDevice currentDevice].name,
   */
  
  NSString *appInfo = [NSString stringWithFormat:@"--- application Info: name:%@,version:%@(%@),system:%@(%@ %@),appPath:%@ ---",
                       app_Name,
                       app_Version,
                       app_build,
                       [UIDevice currentDevice].localizedModel,
                       [UIDevice currentDevice].systemName,
                       [UIDevice currentDevice].systemVersion,
                       appFold];
  return appInfo;
}

+(NSString*) uuid {
  CFUUIDRef puuid = CFUUIDCreate( nil );
  CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
  NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
  CFRelease(puuid);
  CFRelease(uuidString);
  return result;
}

/*-------- for UncaughtExceptionHandler begin --------*/
+ (void)setUncaughtExceptionHandler
{
  DDLogInfo(@"InstallUncaughtExceptionHandler started");
  NSSetUncaughtExceptionHandler(&InstallUncaughtExceptionHandler);
}

+ (NSArray *)backtrace {
  void* callstack[128];
  int frames = backtrace(callstack, 128);
  char **strs = backtrace_symbols(callstack, frames);
  int i;
  
  NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
  for ( i = UncaughtExceptionHandlerSkipAddressCount;i < UncaughtExceptionHandlerSkipAddressCount +UncaughtExceptionHandlerReportAddressCount;i++) {
    [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
  }
  free(strs);
  return backtrace;
}

/*
 // 可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
 NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
 [strException writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

 //调用系统能力 发送邮件
 NSArray *nameArray = [NSArray arrayWithObjects:@"someBody@163.com",nil];
 NSString *urlStr = [NSString stringWithFormat:@"mailto:%@?subject=Megafon-HD Bug Report &body=Thanks for your coorperation!<br><br><br>"
 "AppName:SomeAPP<br>"\
 "Detail:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
 nameArray,
 name,reason,[arr componentsJoinedByString:@"<br>"]];
 
 NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 [[UIApplication sharedApplication] openURL:url];

 NSLog(@"normal:%@",strException);
 */
- (void)handleException:(NSException *)exception {
  
  NSString *strException = [NSString stringWithFormat:@"Terminating app due to uncaught exception:'%@'\n reason:'%@'\n userInfo:%@\n First throw call stack:%@",
                            exception.name,
                            exception.reason,
                            exception.userInfo,
                            exception.callStackSymbols
                            ];
  DDLogError(@"%@",strException);
  
  CFRunLoopRef runLoop = CFRunLoopGetCurrent();
  CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
  
  /*
   while (!dismissed) {
   for (NSString *mode in (__bridge NSArray *)allModes) {
   CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.1, false);
   }
   }
   */
  
  CFRelease(allModes);
  NSSetUncaughtExceptionHandler(NULL);
  signal(SIGABRT, SIG_DFL);
  signal(SIGILL, SIG_DFL);
  signal(SIGSEGV, SIG_DFL);
  signal(SIGFPE, SIG_DFL);
  signal(SIGBUS, SIG_DFL);
  signal(SIGPIPE, SIG_DFL);
  if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
    kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
  }else {
    [exception raise];
  }
}

/*-------- for UncaughtExceptionHandler  end  --------*/


/*-------- for getSysInfoByName start --------*/
#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
  size_t size;
  sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
  
  char *answer = malloc(size);
  sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
  
  NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
  
  free(answer);
  return results;
}

- (NSString *) platform
{
  return [self getSysInfoByName:"hw.machine"];
}

- (NSString *) hwmodel
{
  return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
  size_t size = sizeof(int);
  int results;
  int mib[2] = {CTL_HW, typeSpecifier};
  sysctl(mib, 2, &results, &size, NULL, 0);
  return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
  return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
  return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
  return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
  return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
  return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
  return [self getSysInfo:KIPC_MAXSOCKBUF];
}
/*-------- for getSysInfoByName  end  --------*/

#pragma mark file system -- Thanks Joachim Bean!
/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */
- (NSNumber *) totalDiskSpace
{
  NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
  return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
  NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
  return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (BOOL) hasRetinaDisplay
{
//  return ([UIScreen mainScreen].scale == 2.0f);
return ([UIScreen mainScreen].scale > 1);
}

@end




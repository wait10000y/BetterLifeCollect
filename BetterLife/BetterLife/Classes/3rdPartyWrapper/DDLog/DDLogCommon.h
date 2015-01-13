//
//  DDLogCommon.h
//  BetterLife
//
//  Created by shiliang.wang on 15/1/9.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#ifndef BetterLife_DDLogCommon_h
#define BetterLife_DDLogCommon_h

/*
 * Step 1:
 * Import the header in your implementation file:
 *
 * #import "DDLog.h"
 *
 * Step 2:
 * Define your logging level in your implementation file:
 *
 * // Log levels: off, error, warn, info, verbose
 * static const int ddLogLevel = LOG_LEVEL_VERBOSE;
 *
 * #define LOG_LEVEL_DEF myLibLogLevel
 * static const int myLibLogLevel = LOG_LEVEL_VERBOSE;
 *
 * Step 3:
 * Replace your NSLog statements with DDLog statements according to the severity of the message.
 *
 * NSLog(@"Fatal error, no dohickey found!"); -> DDLogError(@"Fatal error, no dohickey found!");
 *
 
 static const int ddLogLevel = LOG_LEVEL_VERBOSE;
 
 #define LOG_LEVEL_DEF myLibLogLevel
 static const int myLibLogLevel = LOG_LEVEL_VERBOSE;
 */


#import "DDLog.h"

#define LOG_ON_OUT_CONSOLE                1
//#define LOG_ON_OUT_SYSTEM                 1
//#define LOG_ON_OUT_FILE                   1


/*
 #define LOG_LEVEL_OFF
 #define LOG_LEVEL_ERROR
 #define LOG_LEVEL_WARN
 #define LOG_LEVEL_INFO
 #define LOG_LEVEL_DEBUG
 #define LOG_LEVEL_VERBOSE
 */

#define LOGLEVEL_NORMAL               LOG_LEVEL_INFO

#define LOGLEVEL_TestMKNetworkKit     LOG_LEVEL_INFO



#endif

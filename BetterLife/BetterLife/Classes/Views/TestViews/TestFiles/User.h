//
//  User.h
//  BetterLife
//
//  Created by wsliang on 15/10/10.
//  Copyright © 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>


//归档进行 NSCoding
@interface User : NSObject<NSCoding>

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic) int age;
@property (nonatomic) BOOL isAdmin;
@property (nonatomic) NSArray *children;
@property (nonatomic) NSDictionary *friends;

@end

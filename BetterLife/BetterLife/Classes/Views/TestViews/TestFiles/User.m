//
//  User.m
//  BetterLife
//
//  Created by wsliang on 15/10/10.
//  Copyright © 2015年 wsliang. All rights reserved.
//

#import "User.h"

@implementation User

#define NICKNAME @"nickname"
#define EMAIL @"email"
#define AGE @"age"
#define ISADMIN @"isAdmin"
#define CHILDREN @"children"
#define FRIENDS @"friends"

/*
 @property (nonatomic, copy) NSString *nickname;
 @property (nonatomic, copy) NSString *email;
 @property (nonatomic) int age;
 @property (nonatomic) BOOL isAdmin;
 @property (nonatomic) NSArray *friends;
 */
//解归档
-(id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if(self != nil){
    _nickname = [aDecoder decodeObjectForKey:NICKNAME];
    _email = [aDecoder decodeObjectForKey:EMAIL];
    _age = [aDecoder decodeIntForKey:AGE];
    _isAdmin = [aDecoder decodeBoolForKey:ISADMIN];
    _children = [aDecoder decodeObjectForKey:CHILDREN];
    _friends = [aDecoder decodeObjectForKey:FRIENDS];
  }
  return self;
  
}

//归档处理
-(void) encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:_nickname forKey:NICKNAME];
  [aCoder encodeObject:_email forKey:EMAIL];
  [aCoder encodeBool:_isAdmin forKey:ISADMIN];
  [aCoder encodeInt:_age forKey:AGE];
  [aCoder encodeObject:_children forKey:CHILDREN];
  [aCoder encodeObject:_friends forKey:FRIENDS];
}

-(NSString*)description
{
  NSString *readStr = [NSString stringWithFormat:@"<User %lx : nickname = %@, age = %d, email = %@, isAdmin = %d,children = %@, friends = %@ >",
                       self.hash,_nickname,_age,_email,_isAdmin,_children,_friends];
  
  return readStr;
}

@end


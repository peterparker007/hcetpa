//
//  NSObject+UsersData.h
//  ProPad
//
//  Created by vivek on 10/21/15.
//  Copyright © 2015 Zaptech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsersData : NSObject
+ (id)sharedManager;
@property NSMutableDictionary *dictUsersData;
@property NSString *strCheak;
@property NSMutableDictionary *dataDictionary1;

@end

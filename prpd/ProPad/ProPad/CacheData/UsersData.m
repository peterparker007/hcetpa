//
//  NSObject+UsersData.m
//  ProPad
//
//  Created by vivek on 10/21/15.
//  Copyright © 2015 Zaptech. All rights reserved.
//

#import "UsersData.h"

@implementation  UsersData
@synthesize dictUsersData;

+ (id)sharedManager {
    static UsersData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.dictUsersData=[[NSMutableDictionary alloc] init];
        self.strCheak=[NSString new];
        self.dataDictionary1=[[NSMutableDictionary alloc]init];
    }
    return self;
}

@end

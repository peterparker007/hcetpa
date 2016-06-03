//
//  DataBaseHelper.m
//  JobManagement
//
//  Created by Ravi on 27/11/13.
//  Copyright (c) 2013 Aarin. All rights reserved.
//

#import "DataBaseHelper.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "AppDelegate.h"



@implementation DataBaseHelper


-(void)getdata
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"proPad.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSString *query = [NSString stringWithFormat:@"insert into UserInfo values ('%@','%@','%@','%@','%@','%@','%@')", @"test1", @"test2",@"test1",@"test1",@"test1",@"test1",@"test1"];
    [database executeUpdate:query];

    FMResultSet *results = [database executeQuery:@"select * from UserInfo"];
    while([results next]) {
        NSString *name = [results stringForColumn:@"sFirstName"];
        NSString *age  = [results stringForColumn:@"sLastName"];
        NSLog(@"User: %@ - %@",name, age);
    }
    [database close];

}
@end
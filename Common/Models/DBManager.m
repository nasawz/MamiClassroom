//
//  DBManager.m
//  Anyu
//
//  Created by zhe wang on 11-12-29.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "DBManager.h"

#define DB_NAME @"mamiclassroom.db"

@implementation DBManager 

- (BOOL)initDatabase
{
	BOOL success;
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
	
//    NSLog(@"%@",writableDBPath);
    db = [[FMDatabase databaseWithPath:writableDBPath] retain];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        success = YES;
    }else{
        NSLog(@"Failed to open database.");
        success = NO;
    }
    
    if (success) {
        char *errorMsg;
        NSString *createSQL = @""\
        "CREATE TABLE IF NOT EXISTS mamisubjectdetail (         "\
        "id integer NOT NULL,                                   "\
        "title varchar(150) NOT NULL,                           "\
        "cover varchar(150) NOT NULL,                           "\
        "content text NOT NULL,                                 "\
        "type_id integer NOT NULL,                              "\
        "order integer NOT NULL,                                "\
        "PRIMARY KEY (\"id\")                                   "\
        ");                                                     "\
        "                                                       "\
        "                                                       "\
        "CREATE TABLE IF NOT EXISTS mamisubject (               "\
        "id integer NOT NULL,                                   "\
        "title varchar(150) NOT NULL,                           "\
        "cover varchar(150) NOT NULL,                           "\
        "order integer NOT NULL,                                "\
        "content text,                                          "\
        "PRIMARY KEY (\"id\")                                   "\
        ");                                                     "\
        "";
        if (sqlite3_exec([db sqliteHandle], [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
            [db close];
            NSLog(@"Failed to Create table.");
            success = NO;
        }
    }
	
	return success;
}


- (void)closeDatabase
{
	[db close];
}


- (FMDatabase *)getDatabase
{
    return db;
}


- (void)dealloc
{
	[self closeDatabase];
	
	[db release];
	[super dealloc];
}

@end

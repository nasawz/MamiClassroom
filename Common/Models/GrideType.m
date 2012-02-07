//
//  GrideType.m
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "GrideType.h"

@implementation GrideType
@synthesize typeId;
@synthesize title;
@synthesize order;
@synthesize cover;
@synthesize content;

- (GrideType*)initWithJsonDictionary:(NSDictionary*)dic {
    self = [super init];
    
    if (self) {
        self.typeId = [[dic objectForKey:@"pk"] longLongValue];
        self.title = [[dic objectForKey:@"fields"] objectForKey:@"title"];
        self.order = [[[dic objectForKey:@"fields"] objectForKey:@"order"] intValue];    
        self.cover = [[dic objectForKey:@"fields"] objectForKey:@"cover"];
        self.content = [[dic objectForKey:@"fields"] objectForKey:@"content"];
    }
    
    return self;
}

+ (GrideType*)grideTypeWithJsonDictionary:(NSDictionary*)dic {
    return [[[GrideType alloc] initWithJsonDictionary:dic] autorelease];
}

+ (GrideType*)grideTypeWithId:(int)typeId {
    DBManager * dbManager = [[DBManager alloc] init];
    [dbManager initDatabase];
    GrideType * gridType;
    
    NSString *querySQL = @"SELECT * FROM mamisubject WHERE id = ?";
    FMResultSet *rs = [[dbManager getDatabase] executeQuery:querySQL, [NSNumber numberWithInt:typeId]];
    
    if ([rs next]) {
        gridType = [GrideType initWithFMResultSet:rs];
    }
    [rs close];
    
    [dbManager closeDatabase];
	[dbManager release];
    
    return gridType;
}

+ (GrideType*)initWithFMResultSet:(FMResultSet*)rs {
    GrideType * gridType = [[[GrideType alloc] init] autorelease];
    gridType.typeId = [rs intForColumn:@"id"];
    gridType.title = [rs stringForColumn:@"title"];
    gridType.order = [rs intForColumn:@"order"];
    gridType.cover = [rs stringForColumn:@"cover"];
    gridType.content = [rs stringForColumn:@"content"];
    return gridType;    
}

- (void)dealloc {
    [title release];
    title = nil;
    [super dealloc];
}

- (void)insertDB {
    DBManager * dbManager = [[DBManager alloc] init];
    [dbManager initDatabase];
    
    NSString *insertSQL = @"INSERT OR REPLACE INTO mamisubject(id,title,\"order\",cover,content) VALUES (?,?,?,?,?)";        
	[[dbManager getDatabase] executeUpdate:insertSQL, [NSNumber numberWithInt:typeId],title,[NSNumber numberWithInt:order],cover,content];
	if ([[dbManager getDatabase] hadError]) {
		NSLog(@"Err %d: %@", [[dbManager getDatabase] lastErrorCode], [[dbManager getDatabase] lastErrorMessage]);
	}
    
    [dbManager closeDatabase];
	[dbManager release];
}

- (BOOL)isExist {
	BOOL exist = NO;
    
    DBManager * dbManager = [[DBManager alloc] init];
    [dbManager initDatabase];
	
    NSString *querySQL = @"SELECT count(id) as cc FROM mamisubject WHERE id = ?";
    
    
    FMResultSet *rs = [[dbManager getDatabase] executeQuery:querySQL, [NSNumber numberWithInt:typeId]];
    [rs next];
    int count =  [rs intForColumnIndex:0];
    if (count > 0) {
        exist = YES;
    }
    [rs close];
    
    
    [dbManager closeDatabase];
	[dbManager release];
    return exist;
}

- (BOOL)deleteFromDB {
	BOOL success = YES;
    DBManager * dbManager = [[DBManager alloc] init];
    [dbManager initDatabase];
	[[dbManager getDatabase] executeUpdate:@"DELETE FROM mamisubject WHERE id = ?", [NSNumber numberWithInt:typeId]];
	if ([[dbManager getDatabase] hadError]) {
		NSLog(@"Err %d: %@", [[dbManager getDatabase] lastErrorCode], [[dbManager getDatabase] lastErrorMessage]);
		success = NO;
	}
    [dbManager closeDatabase];
	[dbManager release];
	return success;
}

@end

//
//  Gride.m
//  Anyu
//
//  Created by zhe wang on 11-12-30.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "Gride.h"

@implementation Gride 
@synthesize grideId;
@synthesize title;
@synthesize cover;
@synthesize content;
@synthesize type_id;
@synthesize order;
@synthesize isFav;

- (Gride*)initWithJsonDictionary:(NSDictionary*)dic {
    self = [super init];
    
    if (self) {
        self.grideId = [[dic objectForKey:@"pk"] longLongValue];
        self.title = [[dic objectForKey:@"fields"] objectForKey:@"title"];
        self.order = [[[dic objectForKey:@"fields"] objectForKey:@"order"] intValue];
        self.type_id = [[[dic objectForKey:@"fields"] objectForKey:@"type"] intValue];
        self.cover = [[dic objectForKey:@"fields"] objectForKey:@"cover"];
        self.content = [[dic objectForKey:@"fields"] objectForKey:@"content"];
    }
    
    return self;
}

+ (Gride*)grideWithJsonDictionary:(NSDictionary*)dic {
    return [[[Gride alloc] initWithJsonDictionary:dic] autorelease];
}

+ (Gride*)grideWithId:(int)aId {
    DBManager * dbManager = [[DBManager alloc] init];
    [dbManager initDatabase];
    Gride * grid;
    FMResultSet *interRs = [[dbManager getDatabase] executeQuery:@"SELECT * FROM mamisubjectdetail WHERE id = ?",[NSNumber numberWithInt:aId]];
    if ([interRs next]) {
        grid = [Gride initWithFMResultSet:interRs];
    }
    [interRs close];
    
    [dbManager closeDatabase];
	[dbManager release];
    
    return grid;
}

+ (Gride*)initWithFMResultSet:(FMResultSet*)rs {
    Gride * gride = [[[Gride alloc] init] autorelease];
    gride.grideId = [rs intForColumn:@"id"];
    gride.title = [rs stringForColumn:@"title"];
    gride.order = [rs intForColumn:@"order"];
    gride.type_id = [rs intForColumn:@"type_id"];
    gride.cover = [rs stringForColumn:@"cover"];
    gride.content = [rs stringForColumn:@"content"];
    gride.isFav = [rs intForColumn:@"isFav"];
    return gride;
}

- (void)dealloc {
    [title release];
    title = nil;
    [cover release];
    cover = nil;
    [content release];
    content = nil;
    [super dealloc];
}

- (void)insertDB {
    DBManager * dbManager = [[DBManager alloc] init];
    [dbManager initDatabase];
    
    NSString *insertSQL = @"INSERT OR REPLACE INTO mamisubjectdetail(id,cover,content,title,type_id,\"order\",isFav) VALUES (?,?,?,?,?,?,?)";        
	[[dbManager getDatabase] executeUpdate:insertSQL, [NSNumber numberWithInt:grideId],cover,content,title,[NSNumber numberWithInt:type_id],[NSNumber numberWithInt:order],[NSNumber numberWithInt:isFav]];
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
	
    NSString *querySQL = @"SELECT count(id) as cc FROM mamisubjectdetail WHERE id = ?";
    
    
    FMResultSet *rs = [[dbManager getDatabase] executeQuery:querySQL, [NSNumber numberWithInt:grideId]];
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
	[[dbManager getDatabase] executeUpdate:@"DELETE FROM mamisubjectdetail WHERE id = ?", [NSNumber numberWithInt:grideId]];
	if ([[dbManager getDatabase] hadError]) {
		NSLog(@"Err %d: %@", [[dbManager getDatabase] lastErrorCode], [[dbManager getDatabase] lastErrorMessage]);
		success = NO;
	}
    [dbManager closeDatabase];
	[dbManager release];
	return success;
}

@end

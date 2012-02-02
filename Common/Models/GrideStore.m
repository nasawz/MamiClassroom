//
//  GrideStore.m
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "GrideStore.h"

@implementation GrideStore
@synthesize grideArr;

- (id)init {
    self = [super init];
    if (self) {
        dbManager = [[DBManager alloc] init];
        [dbManager initDatabase];
        
        NSString *querySQL = @"SELECT id FROM gridetype order by \"order\" desc";
        
        
        FMResultSet *rs = [[dbManager getDatabase] executeQuery:querySQL];
        grideArr = [[NSMutableArray alloc] init];
        while ([rs next]) {
            
            NSMutableArray * grideids = [[NSMutableArray alloc] init];
            
            FMResultSet *interRs = [[dbManager getDatabase] executeQuery:@"SELECT id as cc FROM gride WHERE type_id = ? and isFav = 1",[NSNumber numberWithInt:[rs intForColumnIndex:0]]];
            while ([interRs next]) {
                [grideids addObject:[NSNumber numberWithInt:[interRs intForColumnIndex:0]]];
            }
            [interRs close];
            
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[rs intForColumnIndex:0]],@"typeid",grideids,@"grideids", nil];
            [grideArr addObject:dic];
        }
        [rs close];        
    }
    return self;
}

- (void)reload {
    NSString *querySQL = @"SELECT id FROM gridetype order by \"order\" desc";
    
    
    FMResultSet *rs = [[dbManager getDatabase] executeQuery:querySQL];
    [grideArr removeAllObjects];
    while ([rs next]) {
        
        NSMutableArray * grideids = [[NSMutableArray alloc] init];
        
        FMResultSet *interRs = [[dbManager getDatabase] executeQuery:@"SELECT id as cc FROM gride WHERE type_id = ? and isFav = 1",[NSNumber numberWithInt:[rs intForColumnIndex:0]]];
        while ([interRs next]) {
            [grideids addObject:[NSNumber numberWithInt:[interRs intForColumnIndex:0]]];
        }
        [interRs close];
        
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[rs intForColumnIndex:0]],@"typeid",grideids,@"grideids", nil];
        [grideArr addObject:dic];
    }
    [rs close];  
}



+ (BOOL)isExistWith:(NSInteger)aGrideId {
    
	BOOL exist = NO;
    
    DBManager * dbManager = [[DBManager alloc] init];
    [dbManager initDatabase];
	
    NSString *querySQL = @"SELECT count(id) as cc FROM gride WHERE id = ?";
    
    
    FMResultSet *rs = [[dbManager getDatabase] executeQuery:querySQL, [NSNumber numberWithInt:aGrideId]];
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

- (void)dealloc {
    
    [grideArr release];
    
    [dbManager closeDatabase];
	[dbManager release];
    [super dealloc];
}
@end

//
//  GrideType.h
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"


@interface GrideType : NSObject{
	int    typeId;
    NSString *  title;
    NSString *  cover;
    int    order;
    NSString *  content;
    
}

@property (nonatomic, assign) int typeId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *cover;
@property (nonatomic, assign) int order;
@property (nonatomic, retain) NSString *content;


+ (GrideType*)grideTypeWithId:(int)typeId;
+ (GrideType*)initWithFMResultSet:(FMResultSet*)rs;

+ (GrideType*)grideTypeWithJsonDictionary:(NSDictionary*)dic;

- (GrideType*)initWithJsonDictionary:(NSDictionary*)dic;

- (void)insertDB;
- (BOOL)isExist;
- (BOOL)deleteFromDB;

@end

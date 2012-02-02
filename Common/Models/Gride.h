//
//  Gride.h
//  Anyu
//
//  Created by zhe wang on 11-12-30.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface Gride : NSObject {
	int    grideId;
    NSString *  title;
    NSString *  cover;
    NSString *  content;
    int    type_id;
    int    order;
    int    isFav;
    
}

@property (nonatomic, assign) int grideId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *cover;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) int type_id;
@property (nonatomic, assign) int order;
@property (nonatomic, assign) int isFav;

+ (Gride*)grideWithId:(int)grideId;
+ (Gride*)initWithFMResultSet:(FMResultSet*)rs;

+ (Gride*)grideWithJsonDictionary:(NSDictionary*)dic;

- (Gride*)initWithJsonDictionary:(NSDictionary*)dic;

- (void)insertDB;
- (BOOL)isExist;
- (BOOL)deleteFromDB;

@end

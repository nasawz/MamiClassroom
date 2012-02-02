//
//  GrideStore.h
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "Gride.h"

@interface GrideStore : NSObject {
    DBManager * dbManager; 
    NSMutableArray * grideArr;
}

@property (nonatomic, readonly) NSMutableArray * grideArr;

- (void)reload;
+ (BOOL)isExistWith:(NSInteger)aGrideId;

@end

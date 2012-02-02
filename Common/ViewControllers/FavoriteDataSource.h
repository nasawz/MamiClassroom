//
//  GrideDataSource.h
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GrideStore.h"
#import "Gride.h"
#import "GrideType.h"

@interface FavoriteDataSource : NSObject <UITableViewDataSource> {
    GrideStore * grideStore;
}


@end

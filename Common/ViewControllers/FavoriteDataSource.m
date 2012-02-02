//
//  GrideDataSource.m
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "FavoriteDataSource.h"

@implementation FavoriteDataSource

- (id)init {
    self = [super init];
    if (self) {
        grideStore = [[GrideStore alloc] init];
    }
    return self;
}

- (void)dealloc {
    [grideStore release];
    [super dealloc];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [grideStore.grideArr count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[grideStore.grideArr objectAtIndex:section] objectForKey:@"grideids"] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    
//    GrideType * gridType = [GrideType grideTypeWithId:[[[grideStore.grideArr objectAtIndex:section] objectForKey:@"typeid"] intValue]];
//    
//    return gridType.title;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"gridecell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gridecell"] autorelease];
    }
    int grideid = [[[[grideStore.grideArr objectAtIndex:[indexPath section]] objectForKey:@"grideids"] objectAtIndex:[indexPath row]] intValue];
    Gride * gride = [Gride grideWithId:grideid];
    cell.textLabel.text = gride.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    int grideid = [[[[grideStore.grideArr objectAtIndex:[indexPath section]] objectForKey:@"grideids"] objectAtIndex:[indexPath row]] intValue];
    Gride * gride = [Gride grideWithId:grideid];
    gride.isFav = 0;
    [gride insertDB];
    [grideStore reload];
    [tableView deleteRow:[indexPath row] inSection:[indexPath section] withRowAnimation:UITableViewRowAnimationFade];
}

@end

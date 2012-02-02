//
//  FavoriteDelegate.m
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "FavoriteDelegate.h"
#import "FavoriteViewController.h"

@implementation FavoriteDelegate
@synthesize favVC = _favVC;

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


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    int grideid = [[[[grideStore.grideArr objectAtIndex:[indexPath section]] objectForKey:@"grideids"] objectAtIndex:[indexPath row]] intValue];
    Gride * gride = [Gride grideWithId:grideid];
    if ([self.favVC respondsToSelector:@selector(openArticleWithType:AndArticle:)]) {
        [self.favVC openArticleWithType:gride.type_id AndArticle:gride.grideId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    GrideType * gridType = [GrideType grideTypeWithId:[[[grideStore.grideArr objectAtIndex:section] objectForKey:@"typeid"] intValue]];
    
    UIImageView * vv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"section_bg.png"]];
    UILabel * lab = [[UILabel alloc] init];
    [lab setFrame:CGRectMake(0, 0, 320, 20)];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setText:[NSString stringWithFormat:@" %@",gridType.title]];
    [lab setShadowColor:[UIColor darkGrayColor]];
    [lab setShadowOffset:CGSizeMake(0, -1)];
    [lab setFont:[UIFont systemFontOfSize:14.0f]];
    [vv addSubview:lab];
    return vv;
}
@end

//
//  FavoriteViewController.h
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteDataSource.h"
#import "FavoriteDelegate.h"

@interface FavoriteViewController : UIViewController <UITableViewDelegate>{
    UIImageView * buttonBar;  
    UITableView * favTableView;
    FavoriteDataSource * favoriteDataSource;
    FavoriteDelegate * favoriteDelegate;
}

- (void)openArticleWithType:(NSInteger)type_id AndArticle:(NSInteger)article_id;

@end

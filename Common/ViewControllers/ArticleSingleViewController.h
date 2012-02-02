//
//  ArticleSingleViewController.h
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ArticleView.h"
#import "ArticleEmView.h"
@interface ArticleSingleViewController : UIViewController {
    UIImageView * buttonBar;
    ArticleEmView * articleView;
}

- (id)initWithType:(NSInteger)type_id AndArticle:(NSInteger)article_id AndModule:(NSString *)module;

@end

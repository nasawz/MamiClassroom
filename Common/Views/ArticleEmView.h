//
//  ArticleEmView.h
//  Anyu
//
//  Created by zhe wang on 12-1-30.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"
#import "IEVTClient.h"
#import "TKLoadingView.h"


@interface ArticleEmView : UIView <SDWebImageManagerDelegate> {
    UIImageView * imageView;
    UITextView * textView;
    UIImageView * favView;    
    
    IEVTClient * client;
    TKLoadingView * loadingView;
    
}

- (void)setImageWithURL:(NSURL *)url;
- (void)cancelCurrentImageLoad;


- (void)openUrl:(NSString *)url;

- (void)getArticleData:(NSString *)type Module:(NSString *)module ArticleID:(NSString *)articleID;

- (void)addFav;
- (void)removeFav;
- (void)setFav:(BOOL)isFav;

@end

//
//  ArticleView.h
//  Anyu
//
//  Created by zhe wang on 11-12-30.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleView : UIView {
    UIImageView * favView;
    UIWebView * webview;
}
- (void)openUrl:(NSString *)url;
- (void)addFav;
- (void)removeFav;
- (void)setFav:(BOOL)isFav;

@end

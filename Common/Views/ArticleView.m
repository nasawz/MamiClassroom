//
//  ArticleView.m
//  Anyu
//
//  Created by zhe wang on 11-12-30.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "ArticleView.h"

@implementation ArticleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 410)];
    if (self) {
        
        webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 410)];
        [self addSubview:webview];
        
        favView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav.png"]];
        [favView setFrame:CGRectMake(286, 8, 35, 31)];
        [self addSubview:favView];
    }
    return self;
}
- (void)addFav {
    [favView setHidden:NO];
}
- (void)removeFav {
    [favView setHidden:YES];    
}

- (void)setFav:(BOOL)isFav {
    [favView setHidden:!isFav]; 
}
- (void)openUrl:(NSString *)url {
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

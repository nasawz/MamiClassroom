//
//  ArticleEmView.m
//  Anyu
//
//  Created by zhe wang on 12-1-30.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "ArticleEmView.h"
#import "GrideStore.h"
#import "Gride.h"


#if TARGET_IPHONE_SIMULATOR
#define     ROOT_DOMAIN      @"127.0.0.1:8000"
#else
#define     ROOT_DOMAIN      @"tumo.im"
#endif

@implementation ArticleEmView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]]];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        textView = [[UITextView alloc] initWithFrame:frame];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setFont:[UIFont systemFontOfSize:16.0f]];
        [textView setEditable:NO];
        [self addSubview:imageView];
        [self addSubview:textView];
        
        
        favView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav.png"]];
        [favView setFrame:CGRectMake(286, 8, 35, 31)];
        [self addSubview:favView];
        [self removeFav];
        
        
        loadingView = [[TKLoadingView alloc] initWithTitle:@"加载中"];
        [loadingView setHidden:YES];
        [loadingView setCenter:CGPointMake(160, 260)];
        [self addSubview:loadingView];
        
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    imageView.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}


- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}



- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    imageView.image = image;
    float ww;
    float hh;
    if (image.size.width != 320) {
        ww = 320;
        hh = image.size.height * (320/image.size.width);
    }
    
    [imageView setSize:CGSizeMake(ww, hh)];
    
    [textView setFrame:CGRectMake(0, hh, 320, textView.frame.size.height - hh)];
}

- (void)openUrl:(NSString *)url {
}

- (void)getArticleData:(NSString *)type Module:(NSString *)module ArticleID:(NSString *)articleID {
    
    
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@/%@/%@",module,type,articleID]
                                    withError:nil];  
    
//    Gride * gride = [Gride grideWithId:[articleID intValue]];
    //    NSLog(@"%@",gride);
    if (![GrideStore isExistWith:[articleID intValue]]) {
        client = [[IEVTClient alloc] initWithTarget:self action:@selector(articleDidLoad:obj:)];
        [client getArticle:type Module:module ArticleID:articleID];
        
        
        [loadingView setHidden:NO];
        [loadingView startAnimating];
        
    }else{
        Gride * gride = [Gride grideWithId:[articleID intValue]];
        [textView setText:[NSString stringWithFormat:@"%@\n%@",gride.title,gride.content]];
        [self setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/site_media/%@",ROOT_DOMAIN,gride.cover]]];
        if (gride.isFav == 1) {
            [self addFav];
        }else{
            [self removeFav];
        }
    }
    
}
- (void)articleDidLoad:(IEVTClient*)c obj:(id)obj {
    
    [loadingView setHidden:YES];
    [loadingView stopAnimating];
    
    if (!c.hasError) {
        if ([c.request isEqualToString:@"articledata"]) {
//            NSLog(@"%@",(NSDictionary *)obj);
            
            
            
            
            Gride * gride = [Gride grideWithJsonDictionary:[(NSArray *)obj objectAtIndex:0]];
            [gride insertDB];
            
            [textView setText:[NSString stringWithFormat:@"%@\n%@",gride.title,gride.content]];
            [self setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/site_media/%@",ROOT_DOMAIN,gride.cover]]];
            [self removeFav];

            
//            _urls = [(NSArray *)obj retain];
//            
//            sv = [[[JSInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 410)
//                                                   dataSource:self
//                                                     delegate:self] autorelease];
//            [self.view addSubview:sv]; 
//            
//            [sv setCurrentIndex:0];
        }
        
    }else{
        NSLog(@"%@",c.errorMessage);
        NSLog(@"%@",c.errorDetail);
    }
    client = nil;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

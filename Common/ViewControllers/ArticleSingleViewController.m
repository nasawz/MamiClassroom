//
//  ArticleSingleViewController.m
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "ArticleSingleViewController.h"
#import "Gride.h"

#if TARGET_IPHONE_SIMULATOR
#define     ROOT_DOMAIN      @"127.0.0.1:8000"
#else
#define     ROOT_DOMAIN      @"tumo.im"
#endif

@implementation ArticleSingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(NSInteger)type_id AndArticle:(NSInteger)article_id AndModule:(NSString *)module {
    self = [super init];
    if (self) {
        NSString * path_bar = [[NSBundle mainBundle] pathForResource:@"buttomBar_bg2" ofType:@"png"];
        UIImage * img_bar = [[UIImage alloc] initWithContentsOfFile:path_bar];
        buttonBar = [[UIImageView alloc] initWithImage:img_bar];
        [buttonBar setUserInteractionEnabled:YES];
        [img_bar release];
        [buttonBar setFrame:CGRectMake(0, self.view.bounds.size.height - buttonBar.frame.size.height, 320, 50)];
        [self.view addSubview:buttonBar];
        
        UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [btnBack setFrame:CGRectMake(0, 0, 48, 48)];
        [btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBar addSubview:btnBack];
        
        UILabel * lab_Title = [[UILabel alloc] initWithFrame:CGRectMake(60, 9, 200, 32)];
        [lab_Title setTextColor:[UIColor whiteColor]];
        [lab_Title setShadowColor:[UIColor darkGrayColor]];
        [lab_Title setShadowOffset:CGSizeMake(0, -1)];
        [lab_Title setTextAlignment:UITextAlignmentCenter];
        [lab_Title setBackgroundColor:[UIColor clearColor]];
        [buttonBar addSubview:lab_Title];
        
        articleView = [[ArticleEmView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-50)];
        [self.view addSubview:articleView];
        
        //        NSString * url = [NSString stringWithFormat:@"http://%@/mami/%@/%d/%d/",ROOT_DOMAIN,module,type_id,article_id];
        
        [articleView getArticleData:[NSString stringWithFormat:@"%d",type_id] Module:module ArticleID:[NSString stringWithFormat:@"%d",article_id]];
        [articleView setFav:YES];
        
        
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/fav/%@/%d/%d",module,type_id,article_id] withError:nil];         
        
        Gride * gride = [Gride grideWithId:article_id];
        lab_Title.text = gride.title;
    }
    return self;
}


- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

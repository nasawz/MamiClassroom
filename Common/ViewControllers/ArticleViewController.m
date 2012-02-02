//
//  ArticleViewController.m
//  Anyu
//
//  Created by zhe wang on 11-12-29.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "ArticleViewController.h"
#import "DBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Gride.h"
#import "ArticleView.h"
#import "ArticleEmView.h"
#import "GrideStore.h"

#if TARGET_IPHONE_SIMULATOR
#define     ROOT_DOMAIN      @"127.0.0.1:8000"
#else
#define     ROOT_DOMAIN      @"tumo.im"
#endif

@implementation ArticleViewController

- (id)initWithType:(NSString *)type Module:(NSString *)module {
    self = [super init];
    if (self) {
        
        _type = [type retain];
        _module = [module retain];
        
        NSLog(@"%@",[NSString stringWithFormat:@"/%@/%@/",_module,_type]);
        
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@/%@/",_module,_type]
                                        withError:nil];  
        
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
        
        btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFav setImage:[UIImage imageNamed:@"btn_bg4.png"] forState:UIControlStateNormal];
        [btnFav setFrame:CGRectMake(320 - 48, 0, 48, 48)];
        [btnFav addTarget:self action:@selector(fav:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBar addSubview:btnFav];        
        
        
        btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTitle setBackgroundImage:[[UIImage imageNamed:@"btn_bg3.png"] stretchableImageWithLeftCapWidth:33.0f topCapHeight:0.0f] forState:UIControlStateNormal];
        [btnTitle setFrame:CGRectMake(60, 9, 200, 32)];
        [btnTitle addTarget:self action:@selector(selectArticle:) forControlEvents:UIControlEventTouchUpInside];
        [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTitle setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTitle.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [buttonBar addSubview:btnTitle];
        
        
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        articlesheet = [[UIActionSheet alloc] initWithTitle:title 
                                                   delegate:self 
                                          cancelButtonTitle:nil 
                                     destructiveButtonTitle:nil 
                                          otherButtonTitles:@"确定", 
                        nil];
        articlesheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        dataPicker = [[UIPickerView alloc] initWithDelegateAndDataSource:self];
        [dataPicker setShowsSelectionIndicator:YES];
        dataPicker.tag = 101;
        [articlesheet addSubview:dataPicker];
        
        
        _currIndex = 0;
        
        loadingView = [[TKLoadingView alloc] initWithTitle:@"加载中"];
        [loadingView setHidden:YES];
        [loadingView setCenter:CGPointMake(160, 260)];
        [self.view addSubview:loadingView];
        
        [self getArticlesType:_type Module:_module];
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    [UIView beginAnimations:@"addad" context:nil];
    [UIView setAnimationDuration:0.6f];
    [bannerView setFrame:CGRectMake(0, 0, 320, 50)];
    [sv setFrame:CGRectMake(0, 50, 320, 410 - 50)];
    [UIView commitAnimations];
    [sv reloadData];
}

#pragma mark - 

- (void)back:(id)sender {
    _currIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)fav:(id)sender {
    Gride * gride = [Gride grideWithId:[[[_urls objectAtIndex:_currIndex] objectForKey:@"pk"] intValue]];
    if (gride.isFav == 1) {
        gride.isFav = 0;
        
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/removefav/%@/%@/%@",_module,_type,[[_urls objectAtIndex:_currIndex] objectForKey:@"pk"]]
                                        withError:nil];
    }else{
        gride.isFav = 1;
        
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/addfav/%@/%@/%@",_module,_type,[[_urls objectAtIndex:_currIndex] objectForKey:@"pk"]]
                                        withError:nil];  
        
    }
    [gride insertDB];
    [sv refresh];
}
- (void)selectArticle:(UIButton *)btn {
    [articlesheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [sv setCurrentIndex:_currIndex];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_urls count];
}
#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	NSString *text = [[[_urls objectAtIndex:row] objectForKey:@"fields"] objectForKey:@"title"];
	UILabel *theLabel = nil;
    theLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 280, 44)];
    [theLabel setTextAlignment:UITextAlignmentCenter];
    [theLabel setBackgroundColor:[UIColor clearColor]];
	theLabel.text = text;
	return theLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _currIndex = row;
}

#pragma mark - method
/***********************************************************************************************************
 * MARK: 缓存数据
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)initializeData:(NSArray *)arr {
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",_module,_type]);
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:[NSString stringWithFormat:@"%@%@",_module,_type]];
}
/***********************************************************************************************************
 * MARK: 初始化
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)initData:(NSArray *)arr {
    
    _urls = [arr retain];
    
    //            NSLog(@"%@",_urls);
    
    sv = [[[JSInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 410)
                                           dataSource:self
                                             delegate:self] autorelease];
    [self.view addSubview:sv]; 
    
    [sv setCurrentIndex:0];
    
    
    CGRect adFrame = CGRectMake(0, -50, 0, 0);
    adFrame.size = GAD_SIZE_320x50;
    bannerView = [[GADBannerView alloc] initWithFrame:adFrame];
    bannerView.rootViewController = self;
    bannerView.adUnitID = @"a14f28f16245cbf";
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    
    GADRequest *request = [GADRequest request];
    
    request.gender = kGADGenderFemale;
    [request setLocationWithDescription:@"China"];
    [request addKeyword:@"Pregnant woman"];
    [request addKeyword:@"Maternal and child"];
    [request addKeyword:@"Health"];
    [request addKeyword:@"Baby"];
    [request addKeyword:@"Milk powder"];
    [request addKeyword:@"Health"];
    
    [bannerView loadRequest:request];
}

- (void)getArticlesType:(NSString *)type Module:(NSString *)module {
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",_module,_type]);
    NSArray * arr = [[NSUserDefaults standardUserDefaults] arrayForKey:[NSString stringWithFormat:@"%@%@",_module,_type]];
    if (arr != nil) {
        [self initData:arr];
    }else{
        [loadingView setHidden:NO];
        [loadingView startAnimating];
    }
    
    client = [[IEVTClient alloc] initWithTarget:self action:@selector(articlesDidLoad:obj:)];
    [client getArticlesType:type Module:module];
}
- (void)articlesDidLoad:(IEVTClient*)c obj:(id)obj {
    
    [loadingView setHidden:YES];
    [loadingView stopAnimating];
    
    if (!c.hasError) {
        if ([c.request isEqualToString:@"articles"]) {
            
            NSArray * arr = [[NSUserDefaults standardUserDefaults] arrayForKey:[NSString stringWithFormat:@"%@%@",_module,_type]];
            if (arr != nil) {
                
                if (![(NSArray *)obj isEqualToArray:arr]) {
                    [self initializeData:(NSArray *)obj];
                    [self initData:(NSArray *)obj];
                }
                
            }else{
                
                [self initializeData:(NSArray *)obj];
                [self initData:(NSArray *)obj];
            }
            
        }
        
    }else{
        NSLog(@"%@",c.errorMessage);
        NSLog(@"%@",c.errorDetail);
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"网络连接失败!"];
    }
    client = nil;
}
#pragma mark - JSInfiniteScrollViewDataSource
- (NSUInteger)numberOfViewsInInfiniteScrollView:(JSInfiniteScrollView *)scrollView
{
	return [_urls count];
}
- (UIView *)infiniteScrollView:(JSInfiniteScrollView*)scrollView viewForIndex:(NSUInteger)index
{
//    NSLog(@"%@",[_urls objectAtIndex:index]);
//    Gride * gride = [Gride grideWithJsonDictionary:[_urls objectAtIndex:index]];
//    BOOL isFav = [gride isExist];
    
    //    NSString * url = [NSString stringWithFormat:@"http://%@/mami/%@/%@/%@/",ROOT_DOMAIN,_module,_type,[[_urls objectAtIndex:index] objectForKey:@"pk"]];
    
    //    ArticleView * articleView = [[ArticleView alloc] initWithFrame:CGRectMake(0, 0, 320, 410)];
    //    [articleView openUrl:url];
    //    [articleView setFav:isFav];
    
    ArticleEmView * articleView = [[ArticleEmView alloc] initWithFrame:CGRectMake(0, 0, 320, sv.frame.size.height)];
    
//    NSLog(@"%@",[[_urls objectAtIndex:index] objectForKey:@"pk"]);
    
    [articleView getArticleData:_type Module:_module ArticleID:[[_urls objectAtIndex:index] objectForKey:@"pk"]];
//    [articleView setFav:isFav];
    
    return articleView;
}
#pragma mark - JSInfiniteScrollViewDelegate
- (void)infiniteScrollView:(JSInfiniteScrollView *)scrollView didScrollToViewAtIndex:(NSUInteger)index {
    NSString *text = [[[_urls objectAtIndex:index] objectForKey:@"fields"] objectForKey:@"title"];
    [btnTitle setTitle:text];
    _currIndex = index;
    [dataPicker selectRow:index inComponent:0 animated:NO];
    
    
    if ([GrideStore isExistWith:[[[_urls objectAtIndex:index] objectForKey:@"pk"] intValue]]) {
        Gride * gride = [Gride grideWithId:[[[_urls objectAtIndex:index] objectForKey:@"pk"] intValue]];
        //    NSLog(@"gride.isFav = %d",gride.isFav);
        //    BOOL isFav = (gride.isFav == 0)?NO:YES;   
        if (gride && gride.isFav == 1) {
            [(ArticleEmView *)[sv currentView] setFav:YES]; 
            [btnFav setImage:[UIImage imageNamed:@"btn_bg4b.png"] forState:UIControlStateNormal];
        }else{
            [btnFav setImage:[UIImage imageNamed:@"btn_bg4.png"] forState:UIControlStateNormal];
        }
        
    }else{
        [btnFav setImage:[UIImage imageNamed:@"btn_bg4.png"] forState:UIControlStateNormal];
    }
    
}
#pragma mark - View lifecycle


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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

//
//  RootViewController.m
//  Anyu
//
//  Created by zhe wang on 11-12-28.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "RootViewController.h"
#import "ArticleViewController.h"
#import "FavoriteViewController.h"
#import "SettingViewController.h"
#import "GrideType.h"
#import "UIImageView+WebCache.h"

#if TARGET_IPHONE_SIMULATOR
#define     ROOT_DOMAIN      @"127.0.0.1:8000"
#else
#define     ROOT_DOMAIN      @"tumo.im"
#endif

@implementation RootViewController
@synthesize shareView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        gridTypeView = [[UITableView alloc] initWithFrame:CGRectMake(20, 265, 280, 145)];
        gridTypeView.dataSource = self;
        gridTypeView.delegate = self;
        [gridTypeView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //        gridTypeView.padding = 8.0f;
        //        [gridTypeView setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:gridTypeView];
        
        NSString * path_bar = [[NSBundle mainBundle] pathForResource:@"buttomBar_bg1" ofType:@"png"];
        UIImage * img_bar = [[UIImage alloc] initWithContentsOfFile:path_bar];
        buttonBar = [[UIImageView alloc] initWithImage:img_bar];
        [buttonBar setUserInteractionEnabled:YES];
        [img_bar release];
        [buttonBar setFrame:CGRectMake(0, self.view.bounds.size.height - buttonBar.frame.size.height, 320, 50)];
        [self.view addSubview:buttonBar];
        
        bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
        [bannerView setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]];
        [self.view addSubview:bannerView];
        UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [line setFrame:CGRectMake(0, 170, 320, 1)];
        [self.view addSubview:line];
        
        //nav
        btnGride = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnGride setFrame:CGRectMake(20, 171, 53, 25)];
        [btnGride setBackgroundImage:[UIImage imageNamed:@"btn_bg2b.png"] forState:UIControlStateNormal];
        [btnGride setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateHighlighted];
        [btnGride setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateSelected];
        [btnGride setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
        [btnGride setTitle:@"育儿画廊" forState:UIControlStateNormal];
        [btnGride setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnGride.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [btnGride addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchDown];
        btnGride.tag = 0;
        [self.view addSubview:btnGride];
        
        
        btnLife = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLife setFrame:CGRectMake(125, 171, 53, 25)];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"btn_bg2b.png"] forState:UIControlStateNormal];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"btn_bg2b.png"] forState:UIControlStateHighlighted];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateSelected];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
        [btnLife setTitle:@"孕期生活" forState:UIControlStateNormal];
        [btnLife setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnLife.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [btnLife addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchDown];
        btnLife.tag = 1;
        [btnLife setHidden:YES];
        [self.view addSubview:btnLife];
        
        btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFav setFrame:CGRectMake(257, 170, 18, 30)];
        [btnFav setImage:[UIImage imageNamed:@"btnFav.png"] forState:UIControlStateNormal];
        [btnFav addTarget:self action:@selector(openFav:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnFav];
        
        //tool
        btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSetting setFrame:CGRectMake(0, 460-48, 48, 48)];
        [btnSetting setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
        [btnSetting addTarget:self action:@selector(goSetting:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btnSetting];
        
        
        btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnShare setFrame:CGRectMake(320-48, 460-48, 48, 48)];
        [btnShare setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [btnShare addTarget:self action:@selector(openShare:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnShare];
        
        introView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grideIntro.png"]];
        [introView setFrame:CGRectMake(16, 205, 287, 55)];
        [self.view addSubview:introView];
        
        
        
        UIImageView * headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headPic.png"]];
        [self.view addSubview:headView];
        
        
        [self changeType:btnGride];
        
        [self getDataWithType:0];
        
        
        shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [self.view addSubview:shareView];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - method

/***********************************************************************************************************
 * MARK: 缓存数据
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)initializeData:(NSArray *)arr {
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"mamisubjects"];
}
/***********************************************************************************************************
 * MARK: 初始化
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)initData:(NSArray *)arr {
    
    
    gridetypes = [arr retain];
    
    [gridTypeView reloadData];
    
    //    for (UIView * vv in gridTypeView.subviews) {
    //        [vv removeFromSuperview];
    //        [vv release];
    //    }
    //    
    //    UIImage * img = [UIImage imageNamed:@"btn_bg1.png"];
    //    UIImage * img2 = [UIImage imageNamed:@"btn_bg1b.png"];
    for (int i = 0; i < [arr count]; i++) {
        
        GrideType * gridType = [GrideType grideTypeWithJsonDictionary:[arr objectAtIndex:i]];
        [gridType insertDB];
    }
}
/***********************************************************************************************************
 * MARK: 获取数据
 ***********************************************************************************************************
 输入参数: 
 type       类别
 ***********************************************************************************************************/
- (void)getDataWithType:(NSInteger)type {
    
    NSArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"mamisubjects"];
    if (arr != nil) {
        [self initData:arr];
    }
    
    client = [[IEVTClient alloc] initWithTarget:self action:@selector(typesDidLoad:obj:)];
    [client getDataWithType:type];
}
- (void)typesDidLoad:(IEVTClient*)c obj:(id)obj {
    if (!c.hasError) {
        if ([c.request isEqualToString:@"mamisubjects"]) {
            gridetypes = [(NSArray *)obj retain];
            
            
            NSArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"mamisubjects"];
            if (arr != nil) {
                
                if (![gridetypes isEqualToArray:arr]) {
                    [self initializeData:gridetypes];
                    [self initData:gridetypes];
                }
                
            }else{
                
                [self initializeData:gridetypes];
                [self initData:gridetypes];
            }
            
        }
        
    }else{
        NSLog(@"%@",c.errorMessage);
        NSLog(@"%@",c.errorDetail);
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"网络连接失败!"];
    }
    client = nil;
}


- (void)openGrideArticle:(NSInteger)index {
    NSString * pk = [[gridetypes objectAtIndex:index] objectForKey:@"pk"];
    ArticleViewController * articleVC = [[ArticleViewController alloc] initWithType:pk Module:@"mamisubjects"];
    [self.navigationController pushViewController:articleVC animated:YES];
    //    [articleVC release];
}
/***********************************************************************************************************
 * MARK: 切换type
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)changeType:(UIButton *)btn {
    if (btn.tag == 0) {
        [btnGride setSelected:YES];
        [btnLife setSelected:NO];
    }else{
        [btnGride setSelected:NO];
        [btnLife setSelected:YES];
    }
}

/***********************************************************************************************************
 * MARK: 打开收藏
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)openFav:(UIButton *)btn {
    FavoriteViewController * favVC = [[FavoriteViewController alloc] init];
    [self.navigationController pushViewController:favVC animated:YES];    
}

/***********************************************************************************************************
 * MARK: 打开分享
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)openShare:(id)sender {
    [shareView open];
}

/***********************************************************************************************************
 * MARK: 打开设置
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)goSetting:(UIButton *)btn {
    SettingViewController * settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

/***********************************************************************************************************
 * MARK: 创建界面
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)buildUI {

}

/***********************************************************************************************************
 * MARK: 生成按钮
 ***********************************************************************************************************
 输入参数: 
 backButtonImage       背景图
 backButtonHighlightImage       高亮背景图
 capWidth       拉伸区域
 title       标题
 ***********************************************************************************************************/
- (UIButton *)typeButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth title:(NSString *)title {
    
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 3.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:title onButton:button leftCapWidth:capWidth];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    
    return button;     
}

/***********************************************************************************************************
 * MARK: 设置按钮文字，并根据文字计算大小
 ***********************************************************************************************************
 输入参数: 
 text       文字
 button       按钮
 capWidth       拉伸区域
 ***********************************************************************************************************/
- (void) setText:(NSString*)text onButton:(UIButton*)button leftCapWidth:(CGFloat)capWidth {
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:button.titleLabel.font];
    textSize.width += 8;
    // Change the button's frame. The width is either the width of the new text or the max width
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, (textSize.width + (capWidth * 1.5)) > 160.0f ? 160.0f : (textSize.width + (capWidth * 1.5)), button.frame.size.height);
    
    // Set the text on the button
    [button setTitle:text forState:UIControlStateNormal];     
}
#pragma mark - View lifecycle



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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gridetypes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"subcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subcell"];
    }
    
    GrideType * gridType = [GrideType grideTypeWithJsonDictionary:[gridetypes objectAtIndex:[indexPath row]]];
//    [gridType insertDB];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    cell.textLabel.text = gridType.title;
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/site_media/%@",ROOT_DOMAIN,gridType.cover]] placeholderImage:[UIImage imageNamed:@"placeholderImage.jpg"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    NSLog(@"%@",[NSString stringWithFormat:@"http://%@/site_media/%@",ROOT_DOMAIN,gridType.cover]);
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self openGrideArticle:[indexPath row]];
}
@end

//
//  FavoriteViewController.m
//  Anyu
//
//  Created by zhe wang on 12-1-4.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ArticleSingleViewController.h"

@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
        
        UIButton * btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEdit setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [btnEdit setFrame:CGRectMake(320 - 48, 0, 48, 48)];
        [btnEdit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBar addSubview:btnEdit];    
        
        
        favoriteDataSource = [[FavoriteDataSource alloc] init];
        favoriteDelegate = [[FavoriteDelegate alloc] init];
        [favoriteDelegate setFavVC:self];
        
        favTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460 - 50) style:UITableViewStylePlain];
        [favTableView setDataSource:favoriteDataSource];
        [favTableView setDelegate:favoriteDelegate];
        [self.view addSubview:favTableView];
        
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[GANTracker sharedTracker] trackPageview:@"/FavoriteView/"
                                    withError:nil]; 
}

- (void)dealloc {
    [favoriteDataSource release];
    favoriteDataSource = nil;
    
    [favoriteDelegate release];
    favoriteDelegate = nil;
    
    [super dealloc];
}


- (void)openArticleWithType:(NSInteger)type_id AndArticle:(NSInteger)article_id {
    ArticleSingleViewController * articleVC = [[ArticleSingleViewController alloc] initWithType:type_id AndArticle:article_id AndModule:@"grides"];
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edit:(id)sender {
    [favTableView setEditing:!favTableView.isEditing animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

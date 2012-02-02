//
//  SettingViewController.m
//  Anyu
//
//  Created by wang zhe on 12-1-7.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "SettingViewController.h"


#define Sina_APPKey @"3838941951"
#define Sina_APPSecret @"2ca0b8230ba9898569035b29398fae99"

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
        
        UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, 320, 460 - 130 - 50)];
        [table setDataSource:self];
        [table setDelegate:self];
        [self.view addSubview:table];
        
        UIImageView * headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_head.png"]];
        [headView setFrame:CGRectMake(0, 0, 320, 130)];
        [self.view addSubview:headView];
        
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[GANTracker sharedTracker] trackPageview:@"/settingView/"
                                    withError:nil];  
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.textLabel setText:@"意见反馈"];
    }
    if (indexPath.row == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.textLabel setText:@"评价我们"];
    }
    if (indexPath.row == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.textLabel setText:@"重置分享"];
    }
    return cell;
}
#pragma mark - 
// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"[安孕]意见反馈"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"service@tumo.im"]; 
//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	
	[picker setToRecipients:toRecipients];
//	[picker setCcRecipients:ccRecipients];	
//	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    if (indexPath.row == 2) {
        
        if( weibo )
        {
            [weibo release];
            weibo = nil;
        }
        weibo = [[WeiBo alloc]initWithAppKey:Sina_APPKey 
                               withAppSecret:Sina_APPSecret];
        [weibo LogOut];
        [[Renren sharedRenren] logout:nil];
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"重置分享成功!"];
    }
    
    if (indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=495095814&type=Purple+Software"]];
    }
    
    if (indexPath.row == 0) {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet];
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    
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

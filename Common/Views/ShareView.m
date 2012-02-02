//
//  ShareView.m
//  Anyu
//
//  Created by wang zhe on 12-1-8.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import "ShareView.h"


#define Sina_APPKey @"3838941951"
#define Sina_APPSecret @"2ca0b8230ba9898569035b29398fae99"

@implementation ShareView
@synthesize weibo;
@synthesize renren;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgbgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_bg.png"]];
        [imgbgView setFrame:CGRectMake(0, 0, 320, 460)];
        [self addSubview:imgbgView];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 320, 460)];
        [btn addTarget:self action:@selector(closeShare:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
            
        btnsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_bg.png"]];
        [btnsView setUserInteractionEnabled:YES];
        [btnsView setFrame:CGRectMake(160, 345, 150, 85)];
        [self addSubview:btnsView];
        
        UIButton * btnSina = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSina setImage:[UIImage imageNamed:@"share_sina.png"] forState:UIControlStateNormal];
        [btnSina setFrame:CGRectMake(15, 13, 120, 24)];
        [btnSina addTarget:self action:@selector(shareSina:) forControlEvents:UIControlEventTouchUpInside];
        [btnsView addSubview:btnSina];
        
        UIButton * btnRenren = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRenren setImage:[UIImage imageNamed:@"share_renren.png"] forState:UIControlStateNormal];
        [btnRenren setFrame:CGRectMake(15, 47, 120, 21)];
        [btnRenren addTarget:self action:@selector(shareRenren:) forControlEvents:UIControlEventTouchUpInside];
        [btnsView addSubview:btnRenren];
        
        [self setHidden:YES];
    }
    return self;
}

- (void)shareSina:(id)sender {
    
    [[GANTracker sharedTracker] trackPageview:@"/shareSina/begin/"
                                    withError:nil];  
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc]initWithAppKey:Sina_APPKey 
						   withAppSecret:Sina_APPSecret];
	weibo.delegate = self;
    
    if (weibo.isUserLoggedin) {
        [weibo showSendViewWithWeiboText:@"我正在使用#安孕#来学习怀孕期间需要注意的各个事项，你也来试试吧～ http://tumo.im/app/anyu/" andImage:[UIImage imageNamed:@"headPic.png"] andDelegate:self];
    }else{
        [weibo startAuthorize];
    }
}
- (void)shareRenren:(id)sender {
    
    
    [[GANTracker sharedTracker] trackPageview:@"/shareRenren/begin/"
                                    withError:nil];  
    
    self.renren = [Renren sharedRenren];
    
    if (![self.renren isSessionValid]) {
		NSArray *permissions = [NSArray arrayWithObjects:@"read_user_album",@"status_update",@"photo_upload",@"publish_feed",@"create_album",@"operate_like",nil];
		[self.renren authorizationWithPermisson:permissions andDelegate:self];
	} else {
//		ServiceTableViewController *serviceTableViewController = [[ServiceTableViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
//		serviceTableViewController.renren = self.renren;
//		[self.navigationController pushViewController:serviceTableViewController animated:YES];
//		[serviceTableViewController release];
        NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"http://tumo.im/app/anyu/",@"url",
                                     @"安孕",@"name",
                                     @"访问我们",@"action_name",
                                     @"http://tumo.im/app/anyu/",@"action_link",
                                     @"来自TUMO(兔毛)",@"description",
                                     @"欢迎使用安孕",@"caption",
                                     @"http://tumo.im/site_media/iphoneapp/anyu180.png",@"image",
                                     @"我正在使用#安孕#来学习怀孕期间需要注意的各个事项，你也来试试吧～ http://tumo.im/app/anyu/",@"message",
                                     nil];
        //        [self.renren dialogInNavigation:@"feed" andParams:params andDelegate:self];
        [self.renren dialog:@"feed" andParams:params andDelegate:self];
	}
}

- (void)open {
    [self setHidden:NO];
}

- (void)closeShare:(id)sender {
    [self setHidden:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - RenrenDelegate
-(void)renrenDidLogin:(Renren *)renren {
    
}
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error{
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error localizedDescription]];
	UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] autorelease];
	[alertView show];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response{
	NSDictionary* params = (NSDictionary *)response.rootObject;
    if (params!=nil) {
        //        NSString *msg=nil;
        //        NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
        //        for (id key in params)
        //		{
        //			msg = [NSString stringWithFormat:@"key: %@ value: %@    ",key,[params objectForKey:key]];
        //		    [result appendString:msg];
        //		}
        //        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Widget Dialog" 
        //                                                       message:result delegate:nil
        //                                             cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //        [alert show];
        //        [alert release];
        //        [result release];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享成功"];
        
        [[GANTracker sharedTracker] trackPageview:@"/shareRenren/end/"
                                        withError:nil]; 
	}
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error{
	//Demo Test
//    NSString* errorCode = [NSString stringWithFormat:@"Error:%d",error.code];
    NSString* errorMsg = [error localizedDescription];
    
    
    [[TKAlertCenter defaultCenter] postAlertWithMessage:errorMsg];
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorCode message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
}

#pragma mark - WBSendViewDelegate

- (void)request:(WBRequest *)request didLoad:(id)result
{
    
    
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送成功！" ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	NSString *urlString = request.url;
	if ([urlString rangeOfString:@"statuses/public_timeline"].location !=  NSNotFound)
	{
		alert.message = @"获取成功";
		NSLog(@"%@",result);
	}
	[alert show];
	[alert release];
	[weibo dismissSendView];
}

- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送失败：%@",[error description] ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
#pragma mark - WBSessionDelegate
//- (void)weiboDidLogin
//{
//	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
//													   message:@"用户验证已成功！" 
//													  delegate:nil 
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];
//}
//
//- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error
//{
//	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"用户验证失败！"  
//													   message:userCancelled?@"用户取消操作":[error description]  
//													  delegate:nil
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];
//}
//
//- (void)weiboDidLogout
//{
//	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
//													   message:@"用户已成功退出！" 
//													  delegate:nil 
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];
//}

@end

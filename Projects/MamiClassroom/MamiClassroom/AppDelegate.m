//
//  AppDelegate.m
//  MamiClassroom
//
//  Created by zhe wang on 12-2-2.
//  Copyright (c) 2012年 tumo.im. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}



- (void)startTrack {
    // **************************************************************************
    // PLEASE REPLACE WITH YOUR ACCOUNT DETAILS.
    // **************************************************************************
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-28970409-1"
                                           dispatchPeriod:10
                                                 delegate:nil];
    
    NSError *error;
    
    
    if (![[GANTracker sharedTracker] trackPageview:@"/start"
                                         withError:&error]) {
        // Handle error here
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startTrack];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    rootViewController = [[RootViewController alloc] init];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navigationController setNavigationBarHidden:YES];
    [self.window setRootViewController:navigationController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

//for ios version below 4.2
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	if( [rootViewController.shareView.weibo handleOpenURL:url] )
		return TRUE;
	
	return TRUE;
}

//for ios version is or above 4.2
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if( [rootViewController.shareView.weibo handleOpenURL:url] )
		return TRUE;
	
	return TRUE;
}

#pragma mark - AppDelegate

+(AppDelegate*)getAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end

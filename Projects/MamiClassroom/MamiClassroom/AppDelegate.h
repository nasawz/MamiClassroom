//
//  AppDelegate.h
//  MamiClassroom
//
//  Created by zhe wang on 12-2-2.
//  Copyright (c) 2012年 tumo.im. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController * navigationController;
    RootViewController * rootViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController * navigationController;

+ (AppDelegate*)getAppDelegate;
@end

//
//  SettingViewController.h
//  Anyu
//
//  Created by wang zhe on 12-1-7.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TKAlertCenter.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate> {
    UIImageView * buttonBar; 
    
    WeiBo* weibo;
    Renren *renren;
}

@end

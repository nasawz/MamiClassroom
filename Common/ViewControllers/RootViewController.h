//
//  RootViewController.h
//  Anyu
//
//  Created by zhe wang on 11-12-28.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESFlowLayoutView.h"
#import "ShareView.h"
#import "IEVTClient.h"
#import "TKAlertCenter.h"

@interface RootViewController : UIViewController {
    UIImageView * buttonBar;
    UIView*       bannerView;
    UIButton * btnGride;
    UIButton * btnLife;
    
    UIButton * btnFav;
    
    UIButton * btnSetting;
    UIButton * btnShare;
 
    UIImageView * introView;
    
    ESFlowLayoutView * gridTypeView;
    
    
    NSArray * gridetypes;
    
    IEVTClient * client;
    
    ShareView * shareView;
}

@property (nonatomic, retain) ShareView * shareView;

- (void)changeType:(UIButton *)btn;

- (void)buildUI;

- (UIButton *)typeButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth title:(NSString *)title;
- (void) setText:(NSString*)text onButton:(UIButton*)button leftCapWidth:(CGFloat)capWidth;

- (void)getDataWithType:(NSInteger)type;

@end

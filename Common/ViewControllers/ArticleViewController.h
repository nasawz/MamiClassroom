//
//  ArticleViewController.h
//  Anyu
//
//  Created by zhe wang on 11-12-29.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSInfiniteScrollView.h"
#import "IEVTClient.h"
#import "TKLoadingView.h"

#import "TKAlertCenter.h"

#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface ArticleViewController : UIViewController <GADBannerViewDelegate,JSInfiniteScrollViewDataSource,JSInfiniteScrollViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    UIImageView * buttonBar;    
    NSArray * _urls;
    
    IEVTClient * client;
    
    NSString * _type;
    NSString * _module;
    
    UIActionSheet * articlesheet;
    UIPickerView * dataPicker;
    
    UIButton * btnTitle;
    
    
    NSInteger  _currIndex;
    
    JSInfiniteScrollView *sv;
    
    UIButton * btnFav;
    TKLoadingView * loadingView;
    
    
    GADBannerView *bannerView;
}

- (id)initWithType:(NSString *)type Module:(NSString *)module; 

- (void)getArticlesType:(NSString *)type Module:(NSString *)module; 

@end

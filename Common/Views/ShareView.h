//
//  ShareView.h
//  Anyu
//
//  Created by wang zhe on 12-1-8.
//  Copyright (c) 2012年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAlertCenter.h"

@interface ShareView : UIView <WBSessionDelegate,WBSendViewDelegate,WBRequestDelegate,RenrenDelegate>{
    UIImageView * imgbgView;
    UIImageView * btnsView;
    
    WeiBo* weibo;
    Renren *renren;
}

@property (nonatomic,assign,readonly) WeiBo* weibo;
@property (retain,nonatomic)Renren *renren;

- (void)open;

@end

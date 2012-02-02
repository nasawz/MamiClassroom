//
//  IEVTConnection.h
//  CarWeibo
//
//  Created by zhe wang on 11-11-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_IPHONE_SIMULATOR
#define     API_DOMAIN      @"127.0.0.1:8000"
#else
#define     API_DOMAIN      @"tumo.im"
#endif

@interface IEVTConnection : NSObject {
    id                  delegate;
    NSString*           requestURL;
    NSURLConnection*    connection;
    NSMutableData*      buf;
    int                 statusCode;
}

@property (nonatomic, readonly) NSMutableData*      buf;
@property (nonatomic, assign) int                   statusCode;
@property (nonatomic, copy) NSString*               requestURL;

- (id)initWithDelegate:(id)delegate;

- (void)get:(NSString*)URL;
- (void)post:(NSString*)aURL body:(NSString*)body;
- (void)post:(NSString*)aURL data:(NSData*)data;
- (void)cancel;

- (void)IEVTConnectionDidFailWithError:(NSError*)error;
- (void)IEVTConnectionDidFinishLoading:(NSString*)content;


@end

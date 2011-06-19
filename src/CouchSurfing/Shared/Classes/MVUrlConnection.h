//
//  MVUrlConnection.h
//  devianART
//
//  Created by Michal Vašíček on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MVUrlConnectionDelegate;

@interface MVUrlConnection : NSObject {
    id<MVUrlConnectionDelegate> _delegate;
    
    NSURLRequest *_urlRequest;
    NSURLConnection *_actualConnection;
    NSMutableData *_actualData;
    
    BOOL _repairHtml;
}

@property(nonatomic, assign) id<MVUrlConnectionDelegate> delegate;

- (id)initWithUrlString:(NSString *)urlString;
- (id)initWithUrlRequest:(NSURLRequest *)urlRequest;
- (void)sendRequest;
//  Odesle regquest a vysledne html se pokusi trochu zvalidnit
- (void)sendRequestWithHtmlRepair;

@end

@protocol MVUrlConnectionDelegate <NSObject>

@optional
- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseString:(NSString *)responseString;
- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData;

@end
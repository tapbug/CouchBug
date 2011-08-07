//
//  MVUrlConnection.h
//  CouchSurfing
//
//  Created on 3/19/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MVUrlConnectionDelegate;

@interface MVUrlConnection : NSObject {
    id<MVUrlConnectionDelegate> _delegate;
    
    NSURLRequest *_urlRequest;
    NSURLConnection *_actualConnection;
    NSMutableData *_actualData;
}

@property(nonatomic, assign) id<MVUrlConnectionDelegate> delegate;

- (id)initWithUrlString:(NSString *)urlString;
- (id)initWithUrlRequest:(NSURLRequest *)urlRequest;
- (void)sendRequest;

@end

@protocol MVUrlConnectionDelegate <NSObject>

@optional
- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseString:(NSString *)responseString;
- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData;

@end
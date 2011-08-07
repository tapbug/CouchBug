//
//  LoginRequest.h
//  CouchSurfing
//
//  Created on 1/28/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginRequestDelegate;

@interface NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

@end

@interface LoginRequest : NSObject {
    NSString *_username;
    NSString *_password;
    
    id<LoginRequestDelegate> _delegate;
    
    NSURLConnection *_connection;
    NSMutableData *_data;
    
    BOOL _isSuccessfull;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) id<LoginRequestDelegate> delegate;

- (void)login;

@end

@protocol LoginRequestDelegate

- (void)loginRequestDidFinnishLogin:(LoginRequest *)request;
- (void)loginRequestDidFail:(LoginRequest *)request;

@end
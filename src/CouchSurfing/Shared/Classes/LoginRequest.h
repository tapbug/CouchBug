//
//  LoginRequest.h
//  CouchSurfing
//
//  Created on 1/28/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetLanguageRequest.h"

@protocol LoginRequestDelegate;

@interface NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

@end

@interface LoginRequest : NSObject <SetLanguageRequestDelegate>{
    NSString *_username;
    NSString *_password;
    
    id<LoginRequestDelegate> _delegate;
    
    NSURLConnection *_connection;
    NSMutableData *_data;
	
	SetLanguageRequest *_setLanguageRequest;
    
    BOOL _isSuccessfull;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) id<LoginRequestDelegate> delegate;

@property (nonatomic, retain) SetLanguageRequest *setLanguageRequest;

- (void)login;

@end

@protocol LoginRequestDelegate <NSObject>

- (void)loginRequestDidFinnishLogin:(LoginRequest *)request;
- (void)loginRequestDidFail:(LoginRequest *)request;

@end
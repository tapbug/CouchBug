//
//  LoginRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginRequest.h"

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {
    return YES;
}

@end

@interface LoginRequest ()

@property (nonatomic, retain) NSURLConnection *connection;

@end

@implementation LoginRequest

@synthesize username = _username;
@synthesize password = _password;
@synthesize delegate = _delegate;

@synthesize connection = _connection;

- (void)dealloc {
    self.username = nil;
    self.password = nil;
    
    [self.connection cancel];
    self.connection = nil;
    
    [super dealloc];
}

- (void)login {
    NSMutableString *requestString = [NSMutableString string];
    
    [requestString appendFormat:@"auth_login[un]=%@", self.username];
    [requestString appendFormat:@"&auth_login[pw]=%@", self.password];
    [requestString appendFormat:@"&auth_login[action]=%@", @"Secure login..."];
    //vyzjistit zda je to nutne
    //[requestString appendFormat:@"&auth_login[timezone_offset]=%@", @"-60"];
    
    NSURL *url = [NSURL URLWithString:@"https://www.couchsurfing.org/login.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    if (response != nil) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *headers = [httpResponse allHeaderFields];
        if ([[headers objectForKey:@"Location"] isEqual:@"/home.html?login=1"]) {
            _isSuccessfull = YES;
        }
        return nil;
    }
    return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_isSuccessfull) {
        [self.delegate loginRequestDidFinnishLogin:self];
    } else {
        [self.delegate loginRequestDidFail:self];
    }

    [_data release];
}

@end

//
//  MVUrlConnection.m
//  devianART
//
//  Created by Michal Vašíček on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MVUrlConnection.h"
#import "RegexKitLite.h"

@interface MVUrlConnection ()

@property(nonatomic, retain) NSURLRequest *urlRequest;
@property(nonatomic, retain) NSURLConnection *actualConnection;
@property(nonatomic, retain) NSMutableData *actualData;

@end

@implementation MVUrlConnection

@synthesize delegate = _delegate;
@synthesize urlRequest = _urlRequest;
@synthesize actualConnection = _actualConnection;
@synthesize actualData = _actualData;

- (void)dealloc {
    [self.actualConnection cancel];
    self.actualConnection = nil;
    self.urlRequest = nil;
    self.actualData = nil;
    [super dealloc];
}

- (id)initWithUrlRequest:(NSURLRequest *)urlRequest {
    if ((self = [super init])) {
        self.urlRequest = urlRequest;        
    }
    
    return self;
}

- (id)initWithUrlString:(NSString *)urlString {
    if ((self = [super init])) {
        NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
        NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
        self.urlRequest = urlRequest;
    }
    return self;
}

- (void)sendRequest {
    self.actualConnection = [[[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self] autorelease];
}


#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.actualData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.actualData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:@selector(connection:didFinnishLoadingWithResponseString:)]) {
        
        NSString *responseString = [[[NSString alloc] initWithData:self.actualData encoding:NSUTF8StringEncoding] autorelease];        
        [self.delegate connection:self didFinnishLoadingWithResponseString:responseString];
    }
    if ([self.delegate respondsToSelector:@selector(connection:didFinnishLoadingWithResponseData:)]) {
        [self.delegate connection:self didFinnishLoadingWithResponseData:self.actualData];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end

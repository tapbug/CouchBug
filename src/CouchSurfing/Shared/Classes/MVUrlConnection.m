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

//  Opravi html tak aby bylo co nejvice validni
- (NSString *)repairHtmlInString:(NSString *)html;

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
    self.actualConnection = [[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self];
}

- (void)sendRequestWithHtmlRepair {
    self.actualConnection = [[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self];
    _repairHtml = YES;
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
        if (_repairHtml) {
            responseString = [self repairHtmlInString:responseString];
        }
        
        [self.delegate connection:self didFinnishLoadingWithResponseString:responseString];
    }
    if ([self.delegate respondsToSelector:@selector(connection:didFinnishLoadingWithResponseData:)]) {
        NSData *responseData = nil;
        if (_repairHtml) {
            NSString *responseString = [[[NSString alloc] initWithData:self.actualData encoding:NSUTF8StringEncoding] autorelease];
            responseString = [self repairHtmlInString:responseString];
            responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            responseData = self.actualData;
        }
        [self.delegate connection:self didFinnishLoadingWithResponseData:responseData];
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

#pragma Mark private methods

- (NSString *)repairHtmlInString:(NSString *)html {
    return [html stringByReplacingOccurrencesOfRegex:@" (.*?)=[\\\"](.*?) " withString:@" $1=\"$2\" "];
}

@end

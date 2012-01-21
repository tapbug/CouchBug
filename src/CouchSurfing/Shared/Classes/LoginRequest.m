//
//  LoginRequest.m
//  CouchSurfing
//
//  Created on 1/28/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "LoginRequest.h"
#import "TouchXML.h"
#import "RegexKitLite.h"
#import "NSData+UTF8.h"
#import "JSONKit.h"
#import "NSDictionary+URL.h"

@interface LoginRequest ()

@property (nonatomic, retain) NSURLConnection *connection;

// It is used when login is success, but we still need to set language
// before we inform delegate
- (void)loginRequestDidSuccess;

@end

@implementation LoginRequest

@synthesize username = _username;
@synthesize password = _password;
@synthesize delegate = _delegate;

@synthesize connection = _connection;

@synthesize setLanguageRequest = _setLanguageRequest;

- (void)dealloc {
    self.username = nil;
    self.password = nil;
    
    [self.connection cancel];
    self.connection = nil;
    
	self.setLanguageRequest = nil;
	
    [super dealloc];
}

- (void)login {   
	NSDictionary *encoded_data = [NSDictionary dictionaryWithObjectsAndKeys:
								  self.username, @"user",
								  self.password, @"password",
								  @"manual", @"submitted",
								  @"submit", @"submit_button",
								  @"1", @"persistent",
								  nil];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
							[encoded_data JSONString], @"encoded_data",
							@"true", @"csstandard_request",
							@"json", @"type",
							@"false", @"dataonly",
							nil];
	
	NSString *requestString = [params URLQueryStringWithoutMark];
	
    //vyzjistit zda je to nutne
    //[requestString appendFormat:@"&auth_login[timezone_offset]=%@", @"-60"];
    
    NSURL *url = [NSURL URLWithString:@"https://www.couchsurfing.org/login/authenticate"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"text/javascript, text/html, application/xml, text/xml, */*" forHTTPHeaderField:@"Accept"];
	
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
        if ([[headers objectForKey:@"Location"] isEqual:@"https://www.couchsurfing.org/home?login=1"]) {
            _isSuccessfull = YES;
        }
        return nil;
    }
    return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_isSuccessfull) {
        [self loginRequestDidSuccess];
    } else {
		NSDictionary *responseJson = [[_data objectFromJSONData] lastObject];

        if ([[responseJson objectForKey:@"errors"] count] > 0) {
            [self.delegate loginRequestDidFail:self];
        } else {
            [self loginRequestDidSuccess];
        }
        
    }

    [_data release];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma Mark SetLanguageRequestDelegate methods

- (void)setLanguageRequestDidSent:(SetLanguageRequest *)request
{
	if ([self.delegate respondsToSelector:@selector(loginRequestDidFinnishLogin:)]) {
		[self.delegate loginRequestDidFinnishLogin:self];
	}
}

#pragma Mark Private methods

- (void)loginRequestDidSuccess
{
	self.setLanguageRequest = [[[SetLanguageRequest alloc] init] autorelease];
	self.setLanguageRequest.delegate = self;
	[self.setLanguageRequest setDefaultLanguage];
}

@end

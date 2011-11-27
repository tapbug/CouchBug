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
		NSDictionary *ns = [NSDictionary dictionaryWithObject:@"http://www.w3.org/1999/xhtml" forKey:@"x"];
		NSError *error;
		NSString *responseString = [[NSString alloc] initWithData:[_data dataByCleanUTF8] encoding:NSUTF8StringEncoding];
		CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:responseString options:CXMLDocumentTidyHTML error:&error] autorelease];
		
        NSString *titleValue = [[[doc nodesForXPath:@"//x:title/text()" namespaceMappings:ns error:nil] lastObject] stringValue];
        if ([titleValue stringByMatching:@".*Login"]) {
            [self.delegate loginRequestDidFail:self];
        } else {
            [self.delegate loginRequestDidFinnishLogin:self];
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


@end

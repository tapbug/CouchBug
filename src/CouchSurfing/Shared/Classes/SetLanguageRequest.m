//
//  CouchRequest.m
//  CouchSurfing
//
//  Created on 6/28/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "SetLanguageRequest.h"
#import "JSONKit.h"

#import "CouchSurfer.h"

@interface SetLanguageRequest () 

@property (nonatomic, retain) MVUrlConnection *connection;

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value;
- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value;

@end

@implementation SetLanguageRequest

@synthesize delegate = _delegate;
@synthesize connection = _connection;

- (void)dealloc {
	self.connection.delegate = nil;
	self.connection = nil;
	[super dealloc];
}

- (void)setDefaultLanguage {
	NSString *urlString = @"https://www.couchsurfing.org/translation/a_set_user_language/en_US";
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[request setHTTPMethod:@"POST"];
	
	NSDictionary *encodedDict = [NSDictionary dictionary];
	
	NSMutableString *bodyString = [NSMutableString string];
	[bodyString appendString:[self parameter:@"encoded_data" value:[encodedDict JSONString]]];
    [bodyString appendString:[self parameter:@"dataonly" value:@"false"]];
    [bodyString appendString:[self parameter:@"csstandard_request" value:@"true"]];
	[bodyString appendString:[self lastParameter:@"type" value:@"json"]];
	[request setValue:@"text/javascript, text/html, application/xml, text/xml, */*" forHTTPHeaderField:@"Accept"];
	[request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	self.connection = [[[MVUrlConnection alloc] initWithUrlRequest:request] autorelease];
	self.connection.delegate = self;
	[self.connection sendRequest];
}

#pragma Mark MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {	
	if ([self.delegate respondsToSelector:@selector(setLanguageRequestDidSent:)]) {
		[self.delegate setLanguageRequestDidSent:self];
	}
}

#pragma Mark Private methods

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value {
    value = value == nil ? @"" : value;
    return [NSString stringWithFormat:@"%@=%@&", parameter, value];
}

- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value {
    value = value == nil ? @"" : value;
    return [NSString stringWithFormat:@"%@=%@", parameter, value];
}


@end

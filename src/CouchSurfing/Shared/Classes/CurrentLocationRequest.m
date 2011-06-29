//
//  CurrentLocationRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentLocationRequest.h"
#import "TouchXML.h"
#import "JSONKit.h"

@interface CurrentLocationRequest ()

@property (nonatomic, retain) MVUrlConnection *connection;

@end

@implementation CurrentLocationRequest

@synthesize connection = _connection;
@synthesize delegate = _delegate;

- (void)dealloc {
	self.connection.delegate = nil;
	self.connection = nil;
	[super dealloc];
}

- (void)gatherCurrentLocation {
	self.connection = [[MVUrlConnection alloc] initWithUrlString:@"http://www.couchsurfing.org/search"];
	self.connection.delegate = self;
	[self.connection sendRequest];
}

#pragma MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {
	NSDictionary *ns = [NSDictionary dictionaryWithObject:@"http://www.w3.org/1999/xhtml" forKey:@"x"];
    CXMLDocument * doc = [[CXMLDocument alloc] initWithData:responseData options:CXMLDocumentTidyHTML error:nil];
	NSString *locationString = [[[[doc nodesForXPath:@"//x:input[@id='location']/@value" namespaceMappings:ns error:nil] lastObject] stringValue] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	if ([self.delegate respondsToSelector:@selector(currentLocationRequest:didGatherLocation:)]) {
		[self.delegate currentLocationRequest:self didGatherLocation:[locationString objectFromJSONString]];
	}
	[doc release]; doc = nil;
}

@end

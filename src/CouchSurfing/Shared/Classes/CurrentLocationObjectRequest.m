//
//  CurrentLocationRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentLocationObjectRequest.h"
#import "TouchXML.h"
#import "JSONKit.h"

#import "NSData+UTF8.h"

@interface CurrentLocationObjectRequest ()

@property (nonatomic, retain) MVUrlConnection *connection;

@end

@implementation CurrentLocationObjectRequest

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
    CXMLDocument * doc = [[CXMLDocument alloc] initWithData:[responseData dataByCleanUTF8] options:CXMLDocumentTidyHTML error:nil];
	NSString *locationString = [[[[[doc nodesForXPath:@"//x:input[@id='location']/@data" namespaceMappings:ns error:nil] lastObject] stringValue] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if ([self.delegate respondsToSelector:@selector(currentLocationObjectRequest:didGatherLocation:)]) {
		[self.delegate currentLocationObjectRequest:self didGatherLocation:[locationString objectFromJSONString]];
	}
	[doc release]; doc = nil;
}

@end

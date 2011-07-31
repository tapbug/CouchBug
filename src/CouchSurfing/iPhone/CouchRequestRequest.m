//
//  CouchRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CouchRequestRequest.h"
#import "JSONKit.h"

#import "CouchSurfer.h"

@interface CouchRequestRequest () 

@property (nonatomic, retain) MVUrlConnection *connection;

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value;
- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value;

@end

@implementation CouchRequestRequest

@synthesize delegate = _delegate;
@synthesize connection = _connection;

@synthesize arrivalDate = _arrivalDate;
@synthesize departureDate = _departureDate;

@synthesize subject = _subject;
@synthesize message = _message;

@synthesize numberOfSurfers = _numberOfSurfers;
@synthesize arrivalViaId = _arrivalViaId;

@synthesize surfer = _surfer;

- (void)dealloc {
	self.connection.delegate = nil;
	self.connection = nil;
	
	self.arrivalDate = nil;
	self.departureDate = nil;
	
	self.subject = nil;
	self.message = nil;
	
	self.surfer = nil;
	[super dealloc];
}

- (void)sendCouchRequest {
	NSString *urlString = @"http://www.couchsurfing.org/couchrequest/a_create";
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[request setHTTPMethod:@"POST"];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	NSString *arrivalDateString = [dateFormatter stringFromDate:self.arrivalDate];
	NSString *departureDateString = [dateFormatter stringFromDate:self.departureDate];
	
	NSDictionary *encodedDict = [NSDictionary dictionaryWithObjectsAndKeys:
		self.surfer.ident, @"host_id",
		@"classic", @"current_formstyle",
		arrivalDateString, @"date_arrival",
		departureDateString, @"date_departure", 
		[NSString stringWithFormat:@"%d", self.numberOfSurfers], @"number_in_party", 
		[NSString stringWithFormat:@"%d", self.arrivalViaId], @"arriving_via", 
		@"", @"template_name", 
		self.subject, @"subject_classic", 
		self.message, @"message_classic", 
		@"", @"subject_guided", 
		@"", @"message_guided", 
		@"", @"about_host", 
		@"Send CouchRequest", @"send_couchrequest_button_name", 
		@"manual", @"submitted", 
		@"send_couchrequest_button_name", @"submit_button"
		, nil];
	
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
	BOOL couchRequestRequestDidSent = NO;
	NSArray *responseArray = [responseData objectFromJSONData];
	if ([responseArray isKindOfClass:[NSArray class]] && [responseArray count] > 0) {
		NSDictionary *responseDict = [responseArray objectAtIndex:0];
		if (![responseDict isEqual:[NSNull null]]) {
			NSDictionary *dataDict = [responseDict objectForKey:@"data"];
			if (![dataDict isEqual:[NSNull null]]) {
				NSString *messageStr = [dataDict objectForKey:@"message"];
				if ([messageStr isEqual:@"CouchRequest Sent!"]) {
					if ([self.delegate respondsToSelector:@selector(couchRequestRequestDidSent:)]) {
						[self.delegate couchRequestRequestDidSent:self];
						couchRequestRequestDidSent = YES;
					}
				} else {
					NSDictionary *errors = [dataDict objectForKey:@"errors"];
					if (![errors isEqual:[NSNull null]]) {
						if ([self.delegate respondsToSelector:@selector(couchRequestDidFailedWithErrors:)]) {
							[self.delegate couchRequestDidFailedWithErrors:errors];
						}							
					}
				}
			}
		}
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

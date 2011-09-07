//
//  CouchRequest.m
//  CouchSurfing
//
//  Created on 6/28/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "CouchRequestRequest.h"
#import "JSONKit.h"

#import "CouchSurfer.h"

@interface CouchRequestRequest () 

@property (nonatomic, retain) MVUrlConnection *connection;
@property (nonatomic, retain) PreferencesRequest *preferencesRequest;

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value;
- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value;

@end

@implementation CouchRequestRequest

@synthesize delegate = _delegate;
@synthesize connection = _connection;
@synthesize preferencesRequest = _preferencesRequest;

@synthesize dateFormat = _dateFormat;
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
	self.preferencesRequest = nil;
	
	self.dateFormat = nil;
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
	if (self.dateFormat == nil) {
		[dateFormatter setDateFormat:@"MM/dd/yyyy"];		
	} else {
		[dateFormatter setDateFormat:self.dateFormat];
	}
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
						
						if (_isRepaired) {
							NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
							[userDefaults setObject:self.dateFormat forKey:@"dateFormat"];
							[userDefaults synchronize];
						}
						
						[self.delegate couchRequestRequestDidSent:self];
						couchRequestRequestDidSent = YES;
					}
				} else {
					NSDictionary *errors = [dataDict objectForKey:@"errors"];
					if (![errors isEqual:[NSNull null]]) {
						NSString *arrivalError = [errors valueForKey:@"arrival"];
						NSString *departureError = [errors valueForKey:@"departure"];
						
						if ((arrivalError != nil || departureError != nil) && _isRepaired == NO) {
							self.preferencesRequest = [[[PreferencesRequest alloc] init] autorelease];
							self.preferencesRequest.delegate = self;
							[self.preferencesRequest loadPreferences];
						} else if ([self.delegate respondsToSelector:@selector(couchRequestDidFailedWithErrors:)]) {
							[self.delegate couchRequestDidFailedWithErrors:errors];
						}							
					} else {
						NSDictionary *error = [NSDictionary dictionaryWithObject:messageStr
																		  forKey:NSLocalizedString(@"ERROR", nil)];
						[self.delegate couchRequestDidFailedWithErrors:error];
					}
				}
			}
		}
	}
	

}

#pragma PreferencesRequestDelegate methods

- (void)preferencesRequest:(PreferencesRequest *)request didLoadResult:(NSDictionary *)result {
	self.dateFormat = [result objectForKey:@"dateFormat"];
	_isRepaired = YES;
	[self sendCouchRequest];
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

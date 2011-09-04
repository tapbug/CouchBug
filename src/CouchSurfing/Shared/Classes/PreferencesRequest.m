//
//  PreferencesRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 9/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferencesRequest.h"
#import "TouchXML.h"
#import "NSData+UTF8.h"

@interface PreferencesRequest ()

@property (nonatomic, retain) MVUrlConnection *preferencesConnection;

@end

@implementation PreferencesRequest

@synthesize delegate = _delegate;

@synthesize preferencesConnection = _preferencesConnection;

- (void)dealloc {
	self.preferencesConnection = nil;
	[super dealloc];
}

- (void)loadPreferences {
	self.preferencesConnection =
		[[[MVUrlConnection alloc] initWithUrlString:@"http://www.couchsurfing.org/editprofile.html?edit=preferences"] autorelease];
	self.preferencesConnection.delegate = self;
	[self.preferencesConnection sendRequest];
}

#pragma Mark MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {
	NSDictionary *ns = [NSDictionary dictionaryWithObject:@"http://www.w3.org/1999/xhtml" forKey:@"x"];
    CXMLDocument * doc = [[CXMLDocument alloc] initWithData:[responseData dataByCleanUTF8] options:CXMLDocumentTidyHTML error:nil];
	
	CXMLNode *dateFormatNode = [[doc nodesForXPath:@"//x:select[@id='profilepreferencesdate_format_locale']/x:option[@selected='selected']/@value" 
								   namespaceMappings:ns
											   error:nil] lastObject];
	
	NSString *dateFormatValue = [dateFormatNode stringValue];
	
	NSString *dateFormat = nil;
	
	if ([dateFormatValue isEqualToString:@"en_US"]) {
		dateFormat = @"MM/dd/yyyy";
	} else if ([dateFormatValue isEqualToString:@"es_ES"]) {
		dateFormat = @"dd/MM/yyyy";
	} else if ([dateFormatValue isEqualToString:@"de_DE"]) {
		dateFormat = @"dd.MM.yyyy";
	} else if ([dateFormatValue isEqualToString:@"nl_NL"]) {
		dateFormat = @"dd-MM-yyyy";
	}

	NSDictionary *resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:dateFormat, @"dateFormat", nil];
	
	if ([self.delegate respondsToSelector:@selector(preferencesRequest:didLoadResult:)]) {
		[self.delegate preferencesRequest:self didLoadResult:resultDict];
	}
}

@end

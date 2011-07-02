//
//  ProfileRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileRequest.h"
#import "CouchSurfer.h"
#import "TouchXML.h"

@interface ProfileRequest ()

@property (nonatomic, retain) MVUrlConnection *profileConnection;

@end

@implementation ProfileRequest

@synthesize delegate = _delegate;
@synthesize surfer = _surfer;
@synthesize profileConnection = _profileConnection;

- (void)dealloc {
	self.profileConnection.delegate = nil;
	self.profileConnection = nil;
	[super dealloc];
}

- (void)sendProfileRequest {
	self.profileConnection = [[MVUrlConnection alloc] initWithUrlString:[NSString stringWithFormat:@"http://www.couchsurfing.org/profile.html?id=%@", self.surfer.ident]];
	self.profileConnection.delegate = self;
	[self.profileConnection sendRequest];
}

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseString:(NSString *)responseString {
	NSDictionary *ns = [NSDictionary dictionaryWithObject:@"http://www.w3.org/1999/xhtml" forKey:@"x"];
	CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:responseString options:CXMLDocumentTidyHTML error:nil];
	NSString *personalDescription = [[doc nodesForXPath:@"//*[@id='description_title']/following-sibbling::text()" namespaceMappings:ns error:nil] lastObject];
	NSLog(@"%@", personalDescription);
	
	if ([self.delegate respondsToSelector:@selector(profileRequest:didLoadProfileData:)]) {
		[self.delegate profileRequest:self didLoadProfileData:[NSDictionary dictionary]];
	}
	
	[doc release]; doc = nil;
}

@end

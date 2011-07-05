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

+ (NSString *)joinHtmlNodesTextsTogether:(NSArray *)nodes;
+ (NSString *)joinTextNodesTextsTogether:(NSArray *)nodes;

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
	NSError *error;
	CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:responseString options:CXMLDocumentTidyHTML error:&error] autorelease];
		
	//x:p[preceding::x:h2/@id='couchinfo'][following::x:h2[(preceding::x:h2)[last()]/@id='couchinfo']]
	NSArray *couchInfoNodes = [doc nodesForXPath:@"//x:*[preceding-sibling::x:h2/@id='couchinfo'][following::x:h2[(preceding::x:h2)[last()]/@id='couchinfo']][self::x:p or self::x:div]"
								   namespaceMappings:ns
											   error:nil];
	self.surfer.couchInfoHtml = [ProfileRequest joinHtmlNodesTextsTogether:couchInfoNodes];

	NSString *couchInfoShort = [NSString string];
	for (CXMLNode *node in couchInfoNodes) {
		NSString *text = [[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
		if (![text isEqualToString:@""]) {
			couchInfoShort = [couchInfoShort stringByAppendingFormat:@"%@ ", text];
		}
		if ([couchInfoShort length] >= 256) {
			break;
		}
	}
	
	NSLog(@"%@", couchInfoShort);
	
	if (![couchInfoShort isEqualToString:@""]) {
		self.surfer.couchInfoShort = couchInfoShort;		
	}
	
	NSArray *couchInfoKeysNodes = [doc nodesForXPath:@"//x:strong[preceding::x:h2/@id='couchinfo'][following::x:h2[(preceding::x:h2)[last()]/@id='couchinfo']][contains(text(),':')]" namespaceMappings:ns error:nil];
	for (CXMLNode *node in couchInfoKeysNodes) {
		NSString *key = [[[node stringValue] stringByReplacingOccurrencesOfString:@":"
																	   withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSString *value = [[[node nodeForXPath:@"./following-sibling::text()[1]" error:nil] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([key isEqualToString:@"Preferred Gender"]) {
			self.surfer.preferredGender = value;
		} else if ([key isEqualToString:@"Max Surfers Per Night"]) {
			self.surfer.maxSurfersPerNight = value;
		} else if ([key isEqualToString:@"Shared Sleeping Surface"]) {
			self.surfer.sharedSleepSurface = value;
		} else if ([key isEqualToString:@"Shared Room"]) {
			self.surfer.sharedRoom = value;
		}
	}
	self.surfer.profileDataLoaded = YES;
	if ([self.delegate respondsToSelector:@selector(profileRequestDidFillSurfer:withResultDocument:)]) {
		[self.delegate profileRequestDidFillSurfer:self withResultDocument:doc];
	}
	
}

+ (NSString *)joinHtmlNodesTextsTogether:(NSArray *)nodes {
	NSMutableString *text = [NSMutableString string];
	for (CXMLNode *node in nodes) {
		NSString *part = [node XMLString];
		if (![part isEqualToString:@""]) {
			[text appendString:part];
		}
	}
	return text;
}

+ (NSString *)joinTextNodesTextsTogether:(NSArray *)nodes {
	NSMutableString *text = [NSMutableString string];
	for (CXMLNode *node in nodes) {
		NSString *part = [[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"\n"
																																						   withString:@" "];
		if (![part isEqualToString:@""]) {
			[text appendFormat:@"%@ ", part];
		}
	}
	return text;
}

+ (NSString *)parsePersonalDescription:(CXMLDocument *)doc {
	NSDictionary *ns = [NSDictionary dictionaryWithObject:@"http://www.w3.org/1999/xhtml" forKey:@"x"];
	NSArray *personalDescriptionNodes = 
	[doc nodesForXPath:@"//text()[preceding-sibling::x:h2/@id='description_title'][following::x:h2[(preceding::x:h2)[last()]/@id='description_title']] | //*[preceding-sibling::x:h2/@id='description_title'][following::x:h2[(preceding::x:h2)[last()]/@id='description_title']]" 
		  namespaceMappings:ns
					  error:nil];
	return [ProfileRequest joinHtmlNodesTextsTogether:personalDescriptionNodes];
}



@end

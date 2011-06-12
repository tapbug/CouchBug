//
//  ProfileRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileRequest.h"
#import "TouchXML.h"

@interface ProfileRequest ()

@property (nonatomic, retain) MVUrlConnection *loadingConnection;
    
@end

@implementation ProfileRequest

@synthesize delegate = _delegate;
@synthesize loadingConnection = _loadingConnection;

- (void)dealloc {
    self.loadingConnection.delegate = nil;
    self.loadingConnection = nil;
    [super dealloc];
}

- (void)loadProfile {
    NSString *profileUrl = @"https://www.couchsurfing.org/editprofile.html?edit=general";
    self.loadingConnection = [[[MVUrlConnection alloc] initWithUrlString:profileUrl] autorelease];
    self.loadingConnection.delegate = self;
    [self.loadingConnection sendRequest];
}

#pragma mark MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {
    CXMLDocument * doc = [[CXMLDocument alloc] initWithData:responseData options:0 error:nil];
    NSString *firstname = [[doc nodeForXPath:@"//input[@id='profilefirst_name']/@value" error:nil] stringValue];
    NSString *lastname = [[doc nodeForXPath:@"//input[@id='profilelast_name']/@value" error:nil] stringValue];
    
    NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:firstname, @"firstname",
                             lastname, @"lastname",
                             nil];
    if ([self.delegate respondsToSelector:@selector(profileRequest:didLoadProfile:)]) {
        [self.delegate profileRequest:self didLoadProfile:profile];
    }
    
}

@end

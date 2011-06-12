//
//  ProfileRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileRequest.h"
#import "LoginInformation.h"
#import "TouchXML.h"

@interface ProfileRequest ()

@property (nonatomic, assign) id<LoginInformation> loginInformation;

@property (nonatomic, retain) MVUrlConnection *loadingConnection;
@property (nonatomic, retain) LoginRequest *loginRequest;

@end

@implementation ProfileRequest

@synthesize delegate = _delegate;
@synthesize loginInformation = _loginInformation;
@synthesize loadingConnection = _loadingConnection;
@synthesize loginRequest = _loginRequest;

- (id)initWithLoginInformation:(id<LoginInformation>)loginInformation {
    self = [super init];
    if (self) {
        self.loginInformation = loginInformation;
    }
    return self;
}

- (void)dealloc {
    self.loadingConnection.delegate = nil;
    self.loadingConnection = nil;
    self.loginRequest.delegate = nil;
    self.loginRequest = nil;
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

    if (firstname == nil && lastname == nil) {
        if (self.loginRequest == nil) {
            self.loginRequest = [[[LoginRequest alloc] init] autorelease];
            self.loginRequest.delegate = self;
            self.loginRequest.username = self.loginInformation.username;
            self.loginRequest.password = self.loginInformation.password;
            [self.loginRequest login];
        } else {
            //todo request failed (zmena api, neni spojeni ...)
        }
    } else {
        NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:firstname, @"firstname",
                                 lastname, @"lastname",
                                 nil];
        if ([self.delegate respondsToSelector:@selector(profileRequest:didLoadProfile:)]) {
            [self.delegate profileRequest:self didLoadProfile:profile];
        }
    }
    
}

#pragma Mark LoginRequestDelegate

- (void)loginRequestDidFinnishLogin:(LoginRequest *)request {
    [self loadProfile];
}

- (void)loginRequestDidFail:(LoginRequest *)request {
    if ([self.delegate respondsToSelector:@selector(profileRequestFailedToLogin:)]) {
        [self.delegate profileRequestFailedToLogin:self];
    }
}

@end

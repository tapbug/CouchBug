//
//  ProfileRequestFactory.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileRequestFactory.h"
#import "ProfileRequest.h"

@interface ProfileRequestFactory ()

@property (nonatomic, assign) id<LoginInformation> loginInformation;

@end

@implementation ProfileRequestFactory

@synthesize loginInformation = injLoginInformation;

- (void)dealloc {
    self.loginInformation = nil;
    [super dealloc];
}

- (ProfileRequest *)createProfileRequest {
    ProfileRequest *profileRequest = 
        [[[ProfileRequest alloc] initWithLoginInformation:self.loginInformation] autorelease];
    return profileRequest;
}

@end

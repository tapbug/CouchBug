//
//  ProfileRequestFactory.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeRequestFactory.h"
#import "HomeRequest.h"

@interface HomeRequestFactory ()

@property (nonatomic, assign) id<LoginInformation> loginInformation;

@end

@implementation HomeRequestFactory

@synthesize loginInformation = injLoginInformation;

- (void)dealloc {
    self.loginInformation = nil;
    [super dealloc];
}

- (HomeRequest *)createHomeRequest {
    HomeRequest *profileRequest = 
        [[[HomeRequest alloc] initWithLoginInformation:self.loginInformation] autorelease];
    return profileRequest;
}

@end

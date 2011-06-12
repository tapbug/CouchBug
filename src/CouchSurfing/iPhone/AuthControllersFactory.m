//
//  AuthControllersFactory.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthControllersFactory.h"
#import "LoginController.h"
#import "LoginController.h"
#import "LoginAnnouncer.h"

#import "ProfileController.h"

@implementation AuthControllersFactory

@synthesize loginAnnouncer = injLoginAnnouncer;
@synthesize loginInformation = injLoginInformation;

- (LoginController *)createLoginController {
    return [[[LoginController alloc] initWithLoginAnnouncer:self.loginAnnouncer
                                          loginInformation:self.loginInformation
                                  authControllerFactory:self] autorelease];
}

- (ProfileController *)createProfileController {
    return [[[ProfileController alloc] initWithAuthControllersFactory:self] autorelease];
}

@end

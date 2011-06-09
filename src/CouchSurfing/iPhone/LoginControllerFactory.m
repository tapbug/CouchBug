//
//  LoginControllerFactory.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginControllerFactory.h"

#import "LoginController.h"
#import "LoginAnnouncer.h"

@implementation LoginControllerFactory

@synthesize loginAnnouncer = injLoginAnnouncer;
@synthesize loginInformation = injLoginInformation;
@synthesize profileCF = injProfileCF;

- (id)createController {
    LoginController *controller =
        [[[LoginController alloc] initWithLoginAnnouncer: self.loginAnnouncer
                                        loginInformation:self.loginInformation
                                profileControllerFactory:self.profileCF] autorelease];
    
    return controller;
}

@end

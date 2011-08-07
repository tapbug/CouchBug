//
//  AuthControllersFactory.m
//  CouchSurfing
//
//  Created on 6/12/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "AuthControllersFactory.h"
#import "LoginController.h"
#import "LoginController.h"
#import "LoginAnnouncer.h"

#import "HomeController.h"
#import "HomeRequestFactory.h"

@implementation AuthControllersFactory

@synthesize loginAnnouncer = injLoginAnnouncer;
@synthesize loginInformation = injLoginInformation;
@synthesize profileRequestFactory = injProfileRequestFactory;
@synthesize couchSearchResultController = injCouchSearchResultController;
@synthesize activeControllersSetter = injActiveControllersSetter;

- (void)dealloc {
    self.profileRequestFactory = nil;
    [super dealloc];
}

- (LoginController *)createLoginController {
    LoginController *loginController = [[[LoginController alloc] initWithLoginAnnouncer:self.loginAnnouncer
																	  loginInformation:self.loginInformation
																 authControllerFactory:self] autorelease];

	loginController.couchSearchController = self.couchSearchResultController;
	loginController.activeControllersSetter = self.activeControllersSetter;
	return loginController;
}

- (HomeController *)createProfileController {
    HomeController *homeController = [[[HomeController alloc] initWithAuthControllersFactory:self
																	   profileRequestFactory:self.profileRequestFactory
																			  loginAnnouncer:self.loginAnnouncer] autorelease];
	homeController.couchSearchController = self.couchSearchResultController;
	return homeController;
}

@end

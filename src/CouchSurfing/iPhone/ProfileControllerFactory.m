//
//  ProfileControllerFactory.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileControllerFactory.h"
#import "ProfileController.h"
#import "CouchSurfer.h"

@implementation ProfileControllerFactory

@synthesize loginInformation = injLoginInformation;

- (ProfileController *)createProfileControllerWithSurfer:(CouchSurfer *)surfer {
	ProfileController *controller = [[[ProfileController alloc] initWithSurfer:surfer] autorelease];
	controller.loginInformation = self.loginInformation;
	return controller;
}

@end

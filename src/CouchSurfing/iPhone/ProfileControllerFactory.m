//
//  ProfileControllerFactory.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileControllerFactory.h"
#import "ProfileController.h"

@implementation ProfileControllerFactory

- (ProfileController *)createProfileController {
    ProfileController *profileController = [[[ProfileController alloc] init] autorelease];
    return profileController;
}

@end

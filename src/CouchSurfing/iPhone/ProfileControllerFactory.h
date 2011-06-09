//
//  ProfileControllerFactory.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileController;

@interface ProfileControllerFactory : NSObject {
}

- (ProfileController *)createProfileController;

@end

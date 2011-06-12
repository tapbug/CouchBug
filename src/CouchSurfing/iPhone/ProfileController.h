//
//  ProfileController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LogoutRequest.h"
#import "ProfileRequest.h"

@class ActivityOverlap;
@class AuthControllersFactory;

@interface ProfileController : UIViewController <LogoutRequestDelegate, ProfileRequestDelegate>{
    AuthControllersFactory *_authControllersFactory;
    
    ActivityOverlap *_loadingOverlap;
    ProfileRequest *_profileRequest;
    
    ActivityOverlap *_logoutOverlap;
    LogoutRequest *_logoutRequest;
}

- (id)initWithAuthControllersFactory:(AuthControllersFactory *)authControllersFactory;

@end

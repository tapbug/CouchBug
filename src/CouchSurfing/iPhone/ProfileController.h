//
//  ProfileController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVUrlConnection.h"
#import "LogoutRequest.h"

@class MVUrlConnection;
@class ActivityOverlap;
@class AuthControllersFactory;

@interface ProfileController : UIViewController <MVUrlConnectionDelegate, LogoutRequestDelegate>{
    AuthControllersFactory *_authControllersFactory;
    
    ActivityOverlap *_loadingOverlap;
    MVUrlConnection *_loadingConnection;
    
    ActivityOverlap *_logoutOverlap;
    LogoutRequest *_logoutRequest;
}

- (id)initWithAuthControllersFactory:(AuthControllersFactory *)authControllersFactory;

@end

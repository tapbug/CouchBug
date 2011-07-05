//
//  LoginController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginRequest.h"

@protocol LoginAnnouncer;
@protocol LoginInformation;
@class AuthControllersFactory;
@class ActivityOverlap;

@interface LoginController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoginRequestDelegate, UIAlertViewDelegate> {
	UIBarButtonItem *_signUpBarButton;
    UITableView *_loginTabel;
    UITextField *_usernameField;
    UITextField *_passwordField;
    UITextField *_activeTextField;
    
    ActivityOverlap *_activityOverlap;
    
    UIAlertView *_loggedAlert;
    
    LoginRequest *_loginRequest;
    id<LoginAnnouncer> _loginAnnouncer;
    id<LoginInformation> _loginInformation;
    
    AuthControllersFactory *_authControllerFactory;
}

- (id)initWithLoginAnnouncer:(id<LoginAnnouncer>)loginAnnouncer
            loginInformation:(id<LoginInformation>)loginInformation
    authControllerFactory:(AuthControllersFactory *)authControllerFactory;

@end

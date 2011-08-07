//
//  LoginController.h
//  CouchSurfing
//
//  Created on 2/16/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginRequest.h"

@protocol LoginAnnouncer;
@protocol LoginInformation;
@protocol ActiveControllersSetter;
@class AuthControllersFactory;
@class ActivityOverlap;
@class CouchSearchResultController;

@interface LoginController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoginRequestDelegate, UIAlertViewDelegate> {
	UIBarButtonItem *_signUpBarButton;
    UITableView *_loginTabel;
    UITextField *_usernameField;
    UITextField *_passwordField;
    UITextField *_activeTextField;
    
	UIView *_footerView;
	
    ActivityOverlap *_activityOverlap;
    
    UIAlertView *_loggedAlert;
    
    LoginRequest *_loginRequest;
    id<LoginAnnouncer> _loginAnnouncer;
    id<LoginInformation> _loginInformation;
    
    AuthControllersFactory *_authControllerFactory;
	CouchSearchResultController *_couchSearchController;
	id<ActiveControllersSetter> _activeControllersSetter;
}

@property (nonatomic, assign) CouchSearchResultController *couchSearchController;
@property (nonatomic, assign) id<ActiveControllersSetter> activeControllersSetter;

- (id)initWithLoginAnnouncer:(id<LoginAnnouncer>)loginAnnouncer
            loginInformation:(id<LoginInformation>)loginInformation
    authControllerFactory:(AuthControllersFactory *)authControllerFactory;

@end

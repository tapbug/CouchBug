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
@class ProfileControllerFactory;

@interface LoginController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoginRequestDelegate, UIAlertViewDelegate> {
    UITableView *_loginTabel;
    UITextField *_usernameField;
    UITextField *_passwordField;
    UITextField *_activeTextField;
    
    UIView *_activityView;
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_activityLabel;
    
    UIAlertView *_loggedAlert;

    
    LoginRequest *_loginRequest;
    id<LoginAnnouncer> _loginAnnouncer;
    id<LoginInformation> _loginInformation;
    
    ProfileControllerFactory *_profileCF;
}

- (id)initWithLoginAnnouncer:(id<LoginAnnouncer>)loginAnnouncer
            loginInformation:(id<LoginInformation>)loginInformation
    profileControllerFactory:(ProfileControllerFactory *)profileCF;

@end

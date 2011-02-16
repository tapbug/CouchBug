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

@interface LoginController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoginRequestDelegate, UIAlertViewDelegate> {
    UITextField *_usernameInput;
    UITextField *_passwordInput;

    UITableView *_tableView;
    NSArray *_reuseIdentifiers;
    NSArray *_fields;
    
    LoginRequest *_loginRequest;
    id<LoginAnnouncer> _loginAnnouncer;
    id<LoginInformation> _loginInformation;
    
    UIAlertView *_loggedAlert;
    UIAlertView *_logFailAlert;
}

- (id)initWithLoginAnnouncer:(id<LoginAnnouncer>)loginAnnouncer loginInformation:(id<LoginInformation>)loginInformation;

@end

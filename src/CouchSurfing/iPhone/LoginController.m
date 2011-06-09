//
//  LoginController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

#import "LoginAnnouncer.h"
#import "LoginInformation.h"

@interface LoginController ()

@property (nonatomic, retain) LoginRequest *loginRequest;
@property (nonatomic, assign) id<LoginAnnouncer> loginAnnouncer;
@property (nonatomic, assign) id<LoginInformation> loginInformation;

@property(nonatomic, retain) UITextField *usernameField;
@property(nonatomic, retain) UITextField *passwordField;
@property(nonatomic, retain) UIView *activityView;

- (void)loginAction;
- (void)hideLoading;

@end


@implementation LoginController

@synthesize loginRequest = _loginRequest;
@synthesize loginAnnouncer = _loginAnnouncer;
@synthesize loginInformation = _loginInformation;

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize activityView = _activityView;

- (id)initWithLoginAnnouncer:(id<LoginAnnouncer>)loginAnnouncer loginInformation:(id<LoginInformation>)loginInformation {
    if ((self = [super init])) {
        self.loginAnnouncer = loginAnnouncer;
        self.loginInformation = loginInformation;
    }
    
    return self;
}

- (void)dealloc {
    self.loginRequest = nil;
    self.usernameField = nil;
    self.passwordField = nil;
    self.activityView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.activityView = [[[UIView alloc] init] autorelease];
    self.activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.activityView.backgroundColor = [UIColor whiteColor];
    
    _activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.activityView addSubview:_activityIndicator];
    
    _activityLabel = [[[UILabel alloc] init] autorelease];
    _activityLabel.text = NSLocalizedString(@"Try to login to CouchSurf", @"");
    _activityLabel.backgroundColor = [UIColor whiteColor];
    _activityLabel.textColor = [UIColor grayColor];
    [_activityLabel sizeToFit];
    _activityLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.activityView addSubview:_activityLabel];
    
    self.usernameField = [[[UITextField alloc] init] autorelease];
    self.usernameField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.delegate = self;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    
    self.passwordField = [[[UITextField alloc] init] autorelease];
    self.passwordField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    self.passwordField.returnKeyType = UIReturnKeyJoin;
    
    _loginTabel = [[[UITableView alloc] initWithFrame:CGRectMake(10, (int)((self.view.frame.size.height - 108) / 2), self.view.frame.size.width - 20, 108)
                                                style:UITableViewStyleGrouped] autorelease];
    
    _loginTabel.backgroundView = nil;
    _loginTabel.backgroundColor = [UIColor clearColor];
    
    [_loginTabel setScrollEnabled:NO];
    _loginTabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _loginTabel.delegate = self;
    _loginTabel.dataSource = self;
    
    [self.view addSubview:_loginTabel];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"usernameCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"usernameCell"];
            self.usernameField.frame = CGRectMake(110, 0, cell.contentView.frame.size.width - 110, cell.contentView.frame.size.height);
            [cell.contentView addSubview:self.usernameField];
        }
        cell.textLabel.text = NSLocalizedString(@"Username", @"user name in login screen");
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"passwordCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"passwordCell"];
            self.passwordField.frame = CGRectMake(110, 0, cell.contentView.frame.size.width - 110, cell.contentView.frame.size.height);
            [cell.contentView addSubview:self.passwordField];
        }
        cell.textLabel.text = NSLocalizedString(@"Password", @"password in login screen");
        
    }
    
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self loginAction];
    }
    return YES;
}


#pragma mark LoginRequestDelegate

- (void)loginRequestDidFinnishLogin:(LoginRequest *)request {
    [self hideLoading];
    _loggedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logged in", @"")
                                              message:NSLocalizedString(@"You are logged in deviantART", @"")
                                             delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                    otherButtonTitles:nil];
    _loggedAlert.delegate = self;
    [_loggedAlert show];
    [_loggedAlert release];
}

- (void)loginRequestDidFail:(LoginRequest *)request {
    [self hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed", @"")
                                                    message:NSLocalizedString(@"Bad username or password", @"")
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == _loggedAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Private methods

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect addFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];    
    
    CGFloat keyboardHeigh = 0;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardHeigh = addFrame.size.height;
    } else {
        keyboardHeigh = addFrame.size.width;
    }
    
    CGRect viewFrame = self.view.frame;
    
    [UIView beginAnimations:@"showKeyboard" context:nil];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    viewFrame.size.height -= keyboardHeigh - self.tabBarController.tabBar.frame.size.height;
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    CGRect addFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeigh = 0;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardHeigh = addFrame.size.height;
    } else {
        keyboardHeigh = addFrame.size.width;
    }
    
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += keyboardHeigh - self.tabBarController.tabBar.frame.size.height;
    self.view.frame = viewFrame;    
}

- (void)hideLoading {
    [_activityIndicator stopAnimating];
    [self.activityView removeFromSuperview];
}


#pragma mark Private methods

- (void)loginAction {
    
    [self.passwordField resignFirstResponder];
    
    self.activityView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect activityIndicatorFrame = _activityIndicator.frame;
    CGRect activityLabelFrame = _activityLabel.frame;
    activityIndicatorFrame.origin.x = (int)((self.activityView.frame.size.width - activityIndicatorFrame.size.width) / 2);
    activityIndicatorFrame.origin.y = (int)((self.activityView.frame.size.height - activityIndicatorFrame.size.height - 3 - activityLabelFrame.size.height) / 2);
    activityLabelFrame.origin.x = (int)((self.activityView.frame.size.width - activityLabelFrame.size.width) / 2);
    activityLabelFrame.origin.y = (int)((self.activityView.frame.size.height - activityLabelFrame.size.height) / 2 + activityIndicatorFrame.size.height - 3);
    _activityIndicator.frame = activityIndicatorFrame;
    _activityLabel.frame = activityLabelFrame;
    
    [self.view addSubview:self.activityView];
    [_activityIndicator startAnimating];
    
    self.loginRequest = [[[LoginRequest alloc] init] autorelease];
    self.loginRequest.delegate = self;
    self.loginRequest.username = self.usernameField.text;
    self.loginRequest.password = self.passwordField.text;
    [self.loginRequest login];
}

@end

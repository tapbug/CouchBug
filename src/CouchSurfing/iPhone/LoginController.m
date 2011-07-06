//
//  LoginController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

#import "ActivityOverlap.h"

#import "LoginAnnouncer.h"
#import "LoginInformation.h"
#import "AuthControllersFactory.h"
#import "CouchSearchResultController.h"

#import "CSTools.h"

@interface LoginController ()

@property (nonatomic, retain) LoginRequest *loginRequest;
@property (nonatomic, assign) id<LoginAnnouncer> loginAnnouncer;
@property (nonatomic, assign) id<LoginInformation> loginInformation;
@property (nonatomic, retain) AuthControllersFactory *authControllerFactory;

@property (nonatomic, retain) UIBarButtonItem *signUpBarButton;
@property(nonatomic, retain) UITextField *usernameField;
@property(nonatomic, retain) UITextField *passwordField;
@property(nonatomic, retain) ActivityOverlap *activityOverlap;

- (void)loginAction;
- (void)signUpAction;

- (void)hideLoading;
- (void)hideKeyboard;

@end


@implementation LoginController

@synthesize loginRequest = _loginRequest;
@synthesize loginAnnouncer = _loginAnnouncer;
@synthesize loginInformation = _loginInformation;
@synthesize authControllerFactory = _authControllerFactory;
@synthesize couchSearchController = _couchSearchController;

@synthesize signUpBarButton = _signUpBarButton;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize activityOverlap = _activityOverlap;

- (id)initWithLoginAnnouncer:(id<LoginAnnouncer>)loginAnnouncer
            loginInformation:(id<LoginInformation>)loginInformation
    authControllerFactory:(AuthControllersFactory *)authControllerFactory {
    
    if ((self = [super init])) {
        self.loginAnnouncer = loginAnnouncer;
        self.loginInformation = loginInformation;
        self.authControllerFactory = authControllerFactory;
    }
    
    return self;
}

- (void)dealloc {
    self.loginRequest = nil;
    self.authControllerFactory = nil;
    self.usernameField = nil;
    self.passwordField = nil;
    self.activityOverlap = nil;
	self.signUpBarButton = nil;
    [super dealloc];
}

- (void)viewDidLoad {    
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clothBg"]];
	
    //Setup navigation baru
    
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3d4041);
    
    self.navigationItem.rightBarButtonItem = 
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SIGN IN", nil)
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(loginAction)];

	self.signUpBarButton =  
		[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SIGN UP", nil)
										 style:UIBarButtonItemStyleBordered
										target:self
										action:@selector(signUpAction)];
	
	self.navigationItem.leftBarButtonItem = self.signUpBarButton;
	
    self.activityOverlap = [[[ActivityOverlap alloc] initWithView:self.view
                                                           title:NSLocalizedString(@"SIGNING IN", nil)] autorelease];
    
    self.usernameField = [[[UITextField alloc] init] autorelease];
    self.usernameField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.delegate = self;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.text = self.loginInformation.username;
    
    self.passwordField = [[[UITextField alloc] init] autorelease];
    self.passwordField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    self.passwordField.returnKeyType = UIReturnKeyJoin;
    self.passwordField.text = self.loginInformation.password;
    
    _loginTabel = [[[UITableView alloc] initWithFrame:CGRectMake(10, (int)((self.view.frame.size.height - 150) / 2), self.view.frame.size.width - 20, 150)
                                                style:UITableViewStyleGrouped] autorelease];    
    _loginTabel.backgroundView = nil;
    _loginTabel.backgroundColor = [UIColor clearColor];
	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 46)] autorelease];
	UIImageView *logoView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"csLogo"]] autorelease];
	logoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	CGRect logoViewFrame = logoView.frame;
	logoViewFrame.origin.x = (int)(headerView.frame.size.width - logoViewFrame.size.width) / 2;
	logoViewFrame.origin.y = 20;
	logoView.frame = logoViewFrame;

	[headerView addSubview:logoView];
	
	_loginTabel.tableHeaderView = headerView;
	
    [_loginTabel setScrollEnabled:NO];
    _loginTabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _loginTabel.delegate = self;
    _loginTabel.dataSource = self;
    
    [self.view addSubview:_loginTabel];
    
	// TODO odhlaseni od prijimani udalosti
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
	
	[super viewDidLoad];
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
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"usernameCell"] autorelease];
            self.usernameField.frame = CGRectMake(110, 0, cell.contentView.frame.size.width - 110, cell.contentView.frame.size.height);
            [cell.contentView addSubview:self.usernameField];
        }
        cell.textLabel.text = NSLocalizedString(@"USERNAME", nil);
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"passwordCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"passwordCell"] autorelease];
            self.passwordField.frame = CGRectMake(110, 0, cell.contentView.frame.size.width - 110, cell.contentView.frame.size.height);
            [cell.contentView addSubview:self.passwordField];
        }
        cell.textLabel.text = NSLocalizedString(@"PASSWORD", nil);
        
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
}

#pragma mark LoginRequestDelegate

- (void)loginRequestDidFinnishLogin:(LoginRequest *)request {
	[self.couchSearchController shouldReload];
    [self.loginAnnouncer user:request.username hasLoggedWithPassword:request.password];
    [self hideLoading];
    id profileController = [self.authControllerFactory createProfileController];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:profileController] animated:YES];
}

- (void)loginRequestDidFail:(LoginRequest *)request {
    [self hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SORRY", nil)
                                                    message:NSLocalizedString(@"LOGIN ERROR", nil)
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
    
    self.navigationItem.leftBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", nil)
                                          style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(hideKeyboard)] autorelease];

}

- (void)keyboardDidHide:(NSNotification *)notification {
    CGRect addFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeigh = 0;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardHeigh = addFrame.size.height;
    } else {
        keyboardHeigh = addFrame.size.width;
    }
    
	[UIView beginAnimations:@"hideKeyboard" context:nil];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += keyboardHeigh - self.tabBarController.tabBar.frame.size.height;
    self.view.frame = viewFrame;
    [UIView commitAnimations];
	
    self.navigationItem.leftBarButtonItem = self.signUpBarButton;
}

- (void)hideLoading {
    [self.activityOverlap removeOverlap];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


#pragma mark Action methods
// Provede prihlaseni
- (void)loginAction {
    
    [self hideKeyboard];
    
    [self.activityOverlap overlapView];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.loginRequest = [[[LoginRequest alloc] init] autorelease];
    self.loginRequest.delegate = self;
    self.loginRequest.username = self.usernameField.text;
    self.loginRequest.password = self.passwordField.text;
    [self.loginRequest login];
}

- (void)signUpAction {
	NSURL *url = [NSURL URLWithString:@"http://www.couchsurfing.org/register.html"];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)hideKeyboard {
    [_activeTextField resignFirstResponder];
}

@end

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
#import "FlurryAPI.h"

enum HeaderViewTags {
	LabelHeaderViewTag = 1
};

@interface LoginController ()

@property (nonatomic, retain) LoginRequest *loginRequest;
@property (nonatomic, assign) id<LoginAnnouncer> loginAnnouncer;
@property (nonatomic, assign) id<LoginInformation> loginInformation;
@property (nonatomic, retain) AuthControllersFactory *authControllerFactory;

@property (nonatomic, retain) UIView *footerView;

@property (nonatomic, retain) UIBarButtonItem *signUpBarButton;
@property(nonatomic, retain) UITextField *usernameField;
@property(nonatomic, retain) UITextField *passwordField;
@property(nonatomic, retain) ActivityOverlap *activityOverlap;

- (void)loginAction;
- (void)signUpAction;

- (void)hideLoading;
- (void)hideKeyboard;
- (void)countSizes;
@end


@implementation LoginController

@synthesize loginRequest = _loginRequest;
@synthesize loginAnnouncer = _loginAnnouncer;
@synthesize loginInformation = _loginInformation;
@synthesize authControllerFactory = _authControllerFactory;
@synthesize couchSearchController = _couchSearchController;
@synthesize footerView = _footerView;
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
	self.footerView = nil;
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
    
	CGFloat tableViewWidth = self.view.frame.size.width;
	CGFloat footerViewWidth = tableViewWidth;
	CGFloat labelViewWidth = footerViewWidth - 20;
	
	UILabel *label = [[[UILabel alloc] init] autorelease];
	label.frame = CGRectMake((int)(footerViewWidth - labelViewWidth) / 2, 5, labelViewWidth, 0);
	label.tag = LabelHeaderViewTag;
	label.numberOfLines = 0;
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.text = NSLocalizedString(@"LOGIN DESCRIPTION", nil);
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = UIColorFromRGB(0x4c566c);
	label.shadowOffset = CGSizeMake(0, 1);
	label.shadowColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:11];
	label.backgroundColor = [UIColor clearColor];
	
	self.footerView = [[[UIView alloc] init] autorelease];
	self.footerView.frame = CGRectMake(0, 0, footerViewWidth, 0);
	self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.footerView addSubview:label];
		
    _loginTabel = [[[UITableView alloc] initWithFrame:CGRectNull
                                                style:UITableViewStyleGrouped] autorelease];
    _loginTabel.frame = CGRectMake(0, 0, tableViewWidth, 0);
	_loginTabel.backgroundView = nil;
    _loginTabel.backgroundColor = [UIColor clearColor];
	
	[self countSizes];
	
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self countSizes];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

	return self.footerView;
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
	
	[FlurryAPI logEvent:@"Login" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
												 @"SUCCESS", 
												 @"STATUS", 
												 nil]];
}

- (void)loginRequestDidFail:(LoginRequest *)request {
    [self hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SORRY", nil)
                                                    message:NSLocalizedString(@"LOGIN ERROR", nil)
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
	
	[FlurryAPI logEvent:@"Login" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
												 @"FAIL", 
												 @"STATUS", 
												 nil]];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == _loggedAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Private methods

- (void)countSizes {
	UILabel *label = (UILabel *)[self.footerView viewWithTag:LabelHeaderViewTag];
	CGFloat tableViewWidth = self.view.frame.size.width;
	CGFloat footerViewWidth = tableViewWidth;
	CGSize labelViewSize = [label.text sizeWithFont:label.font
									 constrainedToSize:CGSizeMake(footerViewWidth - 20, MAXFLOAT) 
										 lineBreakMode:label.lineBreakMode];
	CGFloat footerViewHeight = labelViewSize.height + 5;
	CGFloat tableViewHeight = 150 + footerViewHeight;

	CGRect labelFrame = label.frame;
	labelFrame.size.height = labelViewSize.height;
	label.frame = labelFrame;
	
	CGRect footerViewFrame = self.footerView.frame;
	footerViewFrame.size.height = footerViewHeight;
	self.footerView.frame = footerViewFrame;
	
	CGRect loginTableFrame = _loginTabel.frame;
	loginTableFrame.size.height = tableViewHeight;
	loginTableFrame.origin.y = (int)(self.view.frame.size.height - tableViewHeight) / 2;
	_loginTabel.frame = loginTableFrame;
}

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

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

@property (nonatomic, retain) UIAlertView *loggedAlert;
@property (nonatomic, retain) UIAlertView *logFailedAlert;

- (void)loginAction;

@end


@implementation LoginController

@synthesize loginRequest = _loginRequest;
@synthesize loginAnnouncer = _loginAnnouncer;
@synthesize loginInformation = _loginInformation;

@synthesize loggedAlert = _loggedAlert;
@synthesize logFailedAlert = _logFailAlert;

- (id)initWithLoginAnnouncer:(id<LoginAnnouncer>)loginAnnouncer loginInformation:(id<LoginInformation>)loginInformation {
    if (self = [super init]) {
        self.loginAnnouncer = loginAnnouncer;
        self.loginInformation = loginInformation;
    }
    
    return self;
}

- (void)dealloc {
    [_reuseIdentifiers release]; _reuseIdentifiers = nil;
    [_fields release]; _fields = nil;
    self.loginRequest = nil;
    self.loggedAlert = nil;
    self.logFailedAlert = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    _reuseIdentifiers = [[NSArray arrayWithObjects:@"usernameCell", @"passwordCell", nil] retain];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _usernameInput = [[[UITextField alloc] init] autorelease];
    _usernameInput.delegate = self;
    _usernameInput.returnKeyType = UIReturnKeyNext;
    _usernameInput.placeholder = NSLocalizedString(@"username", @"");
    _usernameInput.autocorrectionType = UITextAutocorrectionTypeNo;
    _usernameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameInput.text = self.loginInformation.username;
    _passwordInput = [[[UITextField alloc] init] autorelease];
    _passwordInput.delegate = self;
    _passwordInput.returnKeyType = UIReturnKeyGo;
    _passwordInput.placeholder = NSLocalizedString(@"password", @"");
    _passwordInput.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordInput.secureTextEntry = YES;
    _passwordInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordInput.text = self.loginInformation.password;
    _fields = [[NSArray arrayWithObjects:_usernameInput, _passwordInput, nil] retain];

    
    [self.view addSubview:_tableView];
    
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [_reuseIdentifiers objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        UITextField *textField = [_fields objectAtIndex:indexPath.row];
        textField.frame = CGRectMake(10, 10, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height - 20);
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:textField];
    }
        
    return cell;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameInput) {
        [_usernameInput resignFirstResponder];
        [_passwordInput becomeFirstResponder];
    } else if (textField == _passwordInput) {
        [self loginAction];
    }
    return YES;
}

#pragma mark LoginRequestDelegate

- (void)loginRequestDidFinnishLogin:(LoginRequest *)request {
    [self.loginAnnouncer user:_usernameInput.text hasLoggedWithPassword:_passwordInput.text];
    
    self.loggedAlert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome ...", @"") 
                                              message:NSLocalizedString(@"Sucessfully logged", @"")
                                             delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"")
                                    otherButtonTitles:nil] autorelease];
    [self.loggedAlert show];
}

- (void)loginRequestDidFail:(LoginRequest *)request {
    self.logFailedAlert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry ...", @"") 
                                               message:NSLocalizedString(@"Login failed", @"")
                                              delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                     otherButtonTitles:nil] autorelease];
    [self.logFailedAlert show];
}

#pragma mark UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.loggedAlert == alertView) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.logFailedAlert == alertView) {
        [_usernameInput becomeFirstResponder];
    }
}

#pragma mark Private methods

- (void)loginAction {
    self.loginRequest = [[[LoginRequest alloc] init] autorelease];
    self.loginRequest.delegate = self;
    self.loginRequest.username = _usernameInput.text;
    self.loginRequest.password = _passwordInput.text;
    [self.loginRequest login];
}

@end

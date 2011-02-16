//
//  LauncherController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LauncherController.h"

#import "CouchSearchFormControllerFactory.h"
#import "LoginControllerFactory.h"

@interface LauncherController ()

- (void)couchSearchAction;
- (void)loginAction;

@end


@implementation LauncherController

@dynamic searchControllerFactory;
@dynamic loginControllerFactory;

- (void)viewDidLoad {
    UIButton *couchSearchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [couchSearchButton setTitle:NSLocalizedString(@"Couch search", @"") forState:UIControlStateNormal];
    [couchSearchButton sizeToFit];
    [couchSearchButton addTarget:self action:@selector(couchSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:couchSearchButton];

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect loginButtonFrame = loginButton.frame;
    loginButtonFrame.origin.y = couchSearchButton.frame.size.height + 2;
    loginButton.frame = loginButtonFrame;
    [loginButton setTitle:NSLocalizedString(@"Sign in", @"") forState:UIControlStateNormal];
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark Action methods

- (void)couchSearchAction {
    //TODO predelat na ControllerFactory
    [self.navigationController pushViewController:[self.searchControllerFactory createController] animated:YES];
}

- (void)loginAction {
    [self.navigationController pushViewController:[self.loginControllerFactory createController] animated:YES];
}

@end

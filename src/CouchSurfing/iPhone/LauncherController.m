    //
//  LauncherController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LauncherController.h"

#import "CouchSearchFormControllerFactory.h"

@interface LauncherController ()

- (void)couchSearchAction;

@end


@implementation LauncherController

@dynamic searchControllerFactory;

- (void)viewDidLoad {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:NSLocalizedString(@"Couch search", @"") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(couchSearchAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
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

@end

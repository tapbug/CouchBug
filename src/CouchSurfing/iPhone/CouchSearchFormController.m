    //
//  CouchSearchFormController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchFormController.h"

#import "CouchSearchResultControllerFactory.h"
#import "CouchSearchResultController.h"
#import "CouchSearchRequest.h"

@interface CouchSearchFormController ()

@property (nonatomic, assign) UITableView *formTableView;

@end


@implementation CouchSearchFormController

@synthesize formTableView = _formTableView;

@synthesize resultControllerFactory = _resultControllerFactory;

- (void)viewDidLoad {
    
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
    self.resultControllerFactory = nil;
    [super dealloc];
}

- (void)searchAction {

}

@end
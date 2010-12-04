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
#import "CouchSearchRequestFactory.h"
#import "CouchSearchRequest.h"

@interface CouchSearchFormController ()

- (void)searchAction;

@end


@implementation CouchSearchFormController

@synthesize requestFactory = _requestFactory;
@synthesize resultControllerFactory = _resultControllerFactory;

- (void)viewDidLoad {    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:NSLocalizedString(@"Search", @"") forState:UIControlStateNormal];
    [searchButton sizeToFit];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor blueColor];    
    [self.view addSubview:searchButton];
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

#pragma mark Action methods

- (void)searchAction {
    CouchSearchRequest *request = [self.requestFactory createRequest];
    
    request.hasCouch = @"";    
    request.keywordOrAnd = @"0";
    request.regionId = @"0";
    request.radiusType = @"M";
    
    CouchSearchResultController *resultController = [self.resultControllerFactory createControllerWithRequest:request];
    [self.navigationController pushViewController:resultController animated:YES];
}

@end
